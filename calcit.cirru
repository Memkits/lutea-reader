
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |app)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (reel)
              let
                  reel-map $ unsafe-coerce reel 'Map
                  store $ unsafe-coerce (&map:get reel-map :store) 'Map
                  states $ unsafe-coerce (&map:get store :states) 'Map
                  cursor $ or (&map:get states :cursor) ([])
                  ; state $ or (:data states)
                    {} (:content |) (:rendered? false)
                div
                  {} $ :style (merge ui/global ui/fullscreen ui/row)
                  div
                    {} $ :style (merge ui/expand ui/row)
                    if (&map:get store :rendered?)
                      comp-reader-ui $ &map:get store :content
                      textarea $ {}
                        :value $ &map:get store :content
                        :autofocus true
                        :placeholder "|Paste text here, then hit \"Toggle\" button..."
                        :style $ merge ui/expand ui/textarea
                          {}
                            :border $ str "|1px solid " (hsl 0 0 94)
                            :padding "|40px 80px"
                            :background-color $ hsl 0 0 94
                        :on-input $ fn (e d!)
                          d! :content $ unsafe-coerce
                            &map:get (unsafe-coerce e 'Map) :value
                            , 'String
                  a $ {}
                    :class-name $ str-spaced css/link css-toggle
                    :inner-text |Toggle
                    :on-click $ fn (e d!) (d! :toggle-rendered nil)
                  when dev? $ comp-reel (>> states :reel) reel ({})
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-paragraph-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-paragraph-ui (p)
              let
                  words $ unsafe-coerce
                    -> (.!split p pattern-spaces) (to-calcit-data true)
                      filter $ fn (p)
                        not $ blank? p
                    , 'List
                div
                  {} (:class-name css-paragraph) (:tab-index 0)
                  list-> ({})
                    -> words (.join |)
                      map-indexed $ fn (j w)
                        [] j $ if (= w "| ") (<> "| ") (comp-word-ui w)
                  a $ {} (:inner-text |Speech)
                    :class-name $ str-spaced css/link css-speech-button
                    :on-click $ fn (e d!)
                      if-let
                        key $ get-env |azure-key
                        speechQueue p key lang $ fn ()
                        nativeSpeechOne p lang
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-reader-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-reader-ui (content)
              let
                  paragraphs $ -> (.!split content pattern-lines) (to-calcit-data true)
                    filter $ fn (p)
                      not $ blank? p
                div
                  {} $ :style
                    merge ui/expand $ {}
                      :background-color $ hsl 0 0 92
                  list->
                    {} $ :class-name css-content-area
                    -> paragraphs $ map-indexed
                      fn (idx p)
                        [] idx $ memof1-call-by idx comp-paragraph-ui p
                  =< nil |40vh
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-word-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-word-ui (w)
              let
                  chars $ split w |
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
          :examples $ []
          :schema $ :: 'Dynamic
        'css-content-area $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defstyle css-content-area $ {}
              |$0 $ {} (:font-family ui/font-normal) (:font-size 16) (:padding "|40px 80px") (:max-width 960) (:margin "|0 auto")
          :examples $ []
          :schema $ :: 'Dynamic
        'css-paragraph $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defstyle css-paragraph $ {}
              |$0 $ {} (:padding "|30px 30px") (:transition-duration |280ms) (:position :relative) (:border-radius |0px)
                :background-color $ hsl 190 0 92
                :border $ str "|2px solid " (hsl 0 0 90)
                :border-top-width 1
                :border-bottom-width 1
                :border-left $ str "|2px solid " (hsl 0 0 90)
              |$0:hover $ {}
                :border-left-color $ hsl 190 20 96
                :background-color $ hsl 190 0 95
              |$0:focus $ {}
                :background-color $ hsl 190 0 100
                :border-left $ str "|2px solid " (hsl 0 0 100)
                :box-shadow $ str "|0 0 6px " (hsl 0 0 0 0.2)
                :z-index 101
                :border-radius |4px
          :examples $ []
          :schema $ :: 'Dynamic
        'css-speech-button $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defstyle css-speech-button $ {}
              |$0 $ {} (:position :absolute) (:right 4) (:bottom 4) (:font-size 13) (:font-family ui/font-fancy)
          :examples $ []
          :schema $ :: 'Dynamic
        'css-toggle $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defstyle css-toggle $ {}
              |$0 $ {} (:position :fixed) (:top 20) (:right 20)
          :examples $ []
          :schema $ :: 'Dynamic
        'pattern-lines $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def pattern-lines $ new js/RegExp |\n\n+
          :examples $ []
          :schema $ :: 'Dynamic
        'pattern-spaces $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def pattern-spaces $ new js/RegExp |\s+
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input list-> a
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            respo-md.comp.md :refer $ comp-md
            app.config :refer $ dev? lang
            respo-ui.css :as css
            memof.once :refer $ memof1-call memof1-call-by
            |@memkits/azure-speech-util :refer $ speechQueue nativeSpeechOne
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def dev? $ = |dev
              option:unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Dynamic
        'lang $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def lang $ option:unwrap-or (get-env |lang) |en-US
          :examples $ []
          :schema $ :: 'Dynamic
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:storage-key |lutea-reader)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.config)
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op op-data)
              when
                and config/dev? $ not= op :states
                println |Dispatch: op
              reset! *reel $ reel-updater updater @*reel (:: op op-data)
          :examples $ []
          :schema $ :: 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              println "|Running mode:" $ if config/dev? |dev |release
              if config/dev? $ load-console-formatter!
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              .!addEventListener (unsafe-coerce js/window 'JsObject) |beforeunload $ fn (event) (persist-storage!)
              flipped js/setInterval 60000 persist-storage!
              let
                  raw $ .!getItem (unsafe-coerce js/localStorage 'JsObject) (:storage-key config/site)
                when (js-present? raw)
                  dispatch! :hydrate-storage $ parse-cirru-edn (unsafe-coerce raw 'String)
              .!addEventListener (unsafe-coerce js/window 'JsObject) |keydown $ fn (event)
                when
                  and
                    = |e $ unsafe-coerce (.-key event) 'String
                    unsafe-coerce (.-metaKey event) 'Bool
                  dispatch! :toggle-rendered nil
              println "|App started."
          :examples $ []
          :schema $ :: 'Dynamic
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def mount-target $ .!querySelector (unsafe-coerce js/document 'JsObject) |.app
          :examples $ []
          :schema $ :: 'Dynamic
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! () (js/console.log |persist)
              .!setItem (unsafe-coerce js/localStorage 'JsObject) (:storage-key config/site)
                format-cirru-edn $ &map:get (unsafe-coerce @*reel 'Map) :store
          :examples $ []
          :schema $ :: 'Dynamic
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Dynamic
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def store $ {}
              :states $ {}
                :cursor $ []
              :content |
              :rendered? false
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.schema)
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn updater (store op op-id op-time)
              match op
                (:states cursor data) (update-states store cursor data)
                (:content data) (assoc store :content data)
                (:toggle-rendered _) (update store :rendered? not)
                (:hydrate-storage data) data
                _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
