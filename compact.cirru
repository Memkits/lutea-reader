
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                cursor $ or (:cursor states) ([])
                state $ or (:data states)
                  {} (:content "\"") (:rendered? false)
              div
                {} $ :style (merge ui/global ui/fullscreen ui/row)
                div
                  {} $ :style (merge ui/expand ui/row)
                  if (:rendered? state)
                    comp-reader-ui $ :content state
                    textarea $ {}
                      :value $ :content state
                      :autofocus true
                      :placeholder "\"Paste text here, then hit \"Toggle\" button..."
                      :style $ merge ui/expand ui/textarea
                        {}
                          :border $ str "\"1px solid " (hsl 0 0 94)
                          :padding "\"40px 80px"
                      :on-input $ fn (e d!)
                        d! cursor $ assoc state :content (:value e)
                      :on-keydown $ fn (e d!)
                        when
                          and
                            = 13 $ :key-code e
                            :meta? e
                          d! cursor $ update state :rendered? not
                a $ {}
                  :class-name $ str-spaced css/link css-toggle
                  :inner-text "\"Toggle"
                  :on-click $ fn (e d!)
                    d! cursor $ update state :rendered? not
                when dev? $ comp-reel (>> states :reel) reel ({})
        |comp-paragraph-ui $ quote
          defcomp comp-paragraph-ui (p)
            let
                words $ -> (.!split p pattern-spaces) to-calcit-data
                  filter $ fn (p)
                    not $ .blank? p
              div
                {} (:class-name css-paragraph) (:tab-index 0)
                list-> ({})
                  -> words (.join "\" ")
                    map-indexed $ fn (j w)
                      [] j $ if (= w "\" ") (<> "\" ") (comp-word-ui w)
                a $ {} (:inner-text "\"Speech")
                  :class-name $ str-spaced css/link css-speech-button
                  :on-click $ fn (e d!)
                    if-let
                      key $ get-env "\"azure-key"
                      speechQueue p key "\"en-US" $ fn ()
                      nativeSpeechOne p "\"en-US"
        |comp-reader-ui $ quote
          defcomp comp-reader-ui (content)
            let
                paragraphs $ -> (.!split content pattern-lines) to-calcit-data
                  filter $ fn (p)
                    not $ .blank? p
              div
                {} $ :style ui/expand
                list->
                  {} $ :style
                    merge $ {} (:font-family ui/font-normal) (:font-size 16) (:padding "\"40px 80px") (:max-width 960) (:margin "\"0 auto")
                  -> paragraphs $ map-indexed
                    fn (idx p)
                      [] idx $ memof1-call-by idx comp-paragraph-ui p
        |comp-word-ui $ quote
          defcomp comp-word-ui (w)
            let
                chars $ .split w "\""
                len $ count w
              list->
                {} $ :style
                  {} $ :display :inline-block
                map-indexed chars $ fn (idx c)
                  [] idx $ <> c
                    {} $ :color
                      hsl 0 0 $ +
                        &max 0 $ - 50 (* 5 len)
                        * 50 $ pow (/ idx len) 1.2
        |css-paragraph $ quote
          defstyle css-paragraph $ {}
            "\"$0" $ {} (:padding "\"30px 30px") (:transition-duration "\"280ms") (:position :relative)
              :border-left $ str "\"2px solid " (hsl 0 0 100)
            "\"$0:focus" $ {}
              :background-color $ hsl 190 40 96
            "\"$0:hover" $ {}
              :border-left-color $ hsl 190 90 90
        |css-speech-button $ quote
          defstyle css-speech-button $ {}
            "\"$0" $ {} (:position :absolute) (:right 4) (:bottom 4) (:font-size 13) (:font-family ui/font-fancy)
        |css-toggle $ quote
          defstyle css-toggle $ {}
            "\"$0" $ {} (:position :fixed) (:top 20) (:right 20)
        |pattern-lines $ quote
          def pattern-lines $ new js/RegExp "\"\\n\\n+"
        |pattern-spaces $ quote
          def pattern-spaces $ new js/RegExp "\"\\s+"
      :ns $ quote
        ns app.comp.container $ :require (respo-ui.core :as ui)
          respo-ui.core :refer $ hsl
          respo.core :refer $ defcomp defeffect <> >> div button textarea span input list-> a
          respo.css :refer $ defstyle
          respo.comp.space :refer $ =<
          reel.comp.reel :refer $ comp-reel
          respo-md.comp.md :refer $ comp-md
          app.config :refer $ dev?
          respo-ui.css :as css
          memof.once :refer $ memof1-call memof1-call-by
          "\"@memkits/azure-speech-util" :refer $ speechQueue nativeSpeechOne
    |app.config $ {}
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ quote
          def site $ {} (:storage-key "\"lutea-reader")
      :ns $ quote (ns app.config)
    |app.main $ {}
      :defs $ {}
        |*reel $ quote
          defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println "\"Dispatch:" op
            reset! *reel $ reel-updater updater @*reel op op-data
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
            flipped js/setInterval 60000 persist-storage!
            let
                raw $ js/localStorage.getItem (:storage-key config/site)
              when (some? raw)
                dispatch! :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
        |mount-target $ quote
          def mount-target $ .!querySelector js/document |.app
        |persist-storage! $ quote
          defn persist-storage! () (js/console.log "\"persist")
            js/localStorage.setItem (:storage-key config/site)
              format-cirru-edn $ :store @*reel
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (remove-watch *reel :changes) (clear-cache!)
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              reset! *reel $ refresh-reel @*reel schema/store updater
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
      :ns $ quote
        ns app.main $ :require
          respo.core :refer $ render! clear-cache!
          app.comp.container :refer $ comp-container
          app.updater :refer $ updater
          app.schema :as schema
          reel.util :refer $ listen-devtools!
          reel.core :refer $ reel-updater refresh-reel
          reel.schema :as reel-schema
          app.config :as config
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
    |app.schema $ {}
      :defs $ {}
        |store $ quote
          def store $ {}
            :states $ {}
              :cursor $ []
      :ns $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op data op-id op-time)
            case-default op
              do (println "\"unknown op:" op) store
              :states $ update-states store data
              :hydrate-storage data
      :ns $ quote
        ns app.updater $ :require
          respo.cursor :refer $ update-states
