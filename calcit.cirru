
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
      :type-slots $ {} $ :dispatch-op |app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'RegexHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait RegexHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'StringHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait StringHost
            .split-regex $ :: 'Fn $ {}
              :args $ [] 'app.comp.container/StringHost 'app.comp.container/RegexHost
              :return 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :split-regex |split
          :schema $ :: 'Trait
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ decode-map-as (&map:get reel :store) app.schema/Store
                states store.:states
              div
                {} $ :style $ merge ui/global ui/fullscreen ui/row
                div
                  {} $ :style $ merge ui/expand ui/row
                  if store.:rendered? (comp-reader-ui store.:content)
                    textarea $ {} (:value store.:content) (:autofocus true) (:placeholder "|Paste text here, then hit \"Toggle\" button...")
                      :style $ merge ui/expand ui/textarea $ {}
                        :border $ str "|1px solid " $ hsl 0 0 94
                        :padding "|40px 80px"
                        :background-color $ hsl 0 0 94
                      :on-input $ fn (e d!)
                        d! $ Op :content $ event-value
                          assert-type e $ :: 'Map 'Tag 'Dynamic
                a $ {}
                  :class-name $ str-spaced css/link css-toggle
                  :inner-text |Toggle
                  :on-click $ fn (e d!)
                    d! $ Op :toggle-rendered
                when dev? $ comp-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Reel
        'comp-paragraph-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-paragraph-ui (p)
            let
                words $ -> (split-regex p pattern-spaces)
                  filter $ fn (word)
                    not $ blank? word
              div
                {} (:class-name css-paragraph) (:tab-index 0)
                list-> ({})
                  -> (join words |)
                    map-indexed $ fn (j word)
                      [] j $ if (= word "| ") (<> "| ") (comp-word-ui word)
                a $ {} (:inner-text |Speech)
                  :class-name $ str-spaced css/link css-speech-button
                  :on-click $ fn (e d!) (speak-text! p lang)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
        'comp-reader-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-reader-ui (content)
            let
                paragraphs $ -> (split-regex content pattern-lines)
                  filter $ fn (paragraph)
                    not $ blank? paragraph
              div
                {} $ :style $ merge ui/expand
                  {} $ :background-color $ hsl 0 0 92
                list->
                  {} $ :class-name css-content-area
                  -> paragraphs $ map-indexed $ fn (idx paragraph)
                    [] idx $ memof1-call-by idx comp-paragraph-ui paragraph
                =< &unit |40vh
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
        'comp-word-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-word-ui (word)
            let
                chars $ split word |
                len $ count word
              list->
                {} $ :style $ {} (:display :inline-block)
                map-indexed chars $ fn (idx char)
                  [] idx $ <> char $ {}
                    :color $ hsl 0 0 $ +
                      &max 0 $ - 50 $ * 5 len
                      * 50 $ pow (/ idx len) 1.2
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
        'css-content-area $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-content-area
            {} $ |$0 $ {} (:font-family ui/font-normal) (:font-size 16) (:padding "|40px 80px") (:max-width 960) (:margin "|0 auto")
          :examples $ []
          :schema $ :: 'String
        'css-paragraph $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-paragraph
            {}
              |$0 $ {} (:padding "|30px 30px") (:transition-duration |280ms) (:position :relative) (:border-radius |0px)
                :background-color $ hsl 190 0 92
                :border $ str "|2px solid " $ hsl 0 0 90
                :border-top-width 1
                :border-bottom-width 1
                :border-left $ str "|2px solid " $ hsl 0 0 90
              |$0:hover $ {}
                :border-left-color $ hsl 190 20 96
                :background-color $ hsl 190 0 95
              |$0:focus $ {}
                :background-color $ hsl 190 0 100
                :border-left $ str "|2px solid " $ hsl 0 0 100
                :box-shadow $ str "|0 0 6px " $ hsl 0 0 0 (%some 0.2)
                :z-index 101
                :border-radius |4px
          :examples $ []
          :schema $ :: 'String
        'css-speech-button $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-speech-button
            {} $ |$0 $ {} (:position :absolute) (:right 4) (:bottom 4) (:font-size 13) (:font-family ui/font-fancy)
          :examples $ []
          :schema $ :: 'String
        'css-toggle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-toggle
            {} $ |$0 $ {} (:position :fixed) (:top 20) (:right 20)
          :examples $ []
          :schema $ :: 'String
        'event-value $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn event-value (event)
            assert-type (&map:get event :value) 'String
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
        'make-regex $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn make-regex (pattern)
            unsafe-coerce (new js/RegExp pattern) RegexHost
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.comp.container/RegexHost)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'pattern-lines $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def pattern-lines (make-regex |\n\n+)
          :examples $ []
          :schema $ :: 'app.comp.container/RegexHost
        'pattern-spaces $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def pattern-spaces (make-regex |\s+)
          :examples $ []
          :schema $ :: 'app.comp.container/RegexHost
        'speak-text! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn speak-text! (text language)
            match (get-env |azure-key)
              (:some key)
                let
                    speak-queue $ unsafe-coerce speechQueue $ :: 'Fn
                      {} (:return 'Unit)
                        :args $ [] 'String 'String 'String $ :: 'Fn
                          {} (:return 'Unit)
                            :args $ []
                  speak-queue text key language $ fn () &unit
              (:none)
                let
                    speak-native $ unsafe-coerce nativeSpeechOne $ :: 'Fn
                      {} (:return 'Unit)
                        :args $ [] 'String 'String
                  speak-native text language
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
        'split-regex $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn split-regex (text pattern)
            assert-type
              ->
                .split-regex (unsafe-coerce text StringHost) pattern
                to-calcit-data true
              :: 'List 'String
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String 'app.comp.container/RegexHost
            :features $ #{} :js-ffi
            :return $ :: 'List 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require ([] respo-ui.core :as ui)
            [] respo-ui.core :refer $ [] hsl
            [] respo.core :refer $ [] defcomp defeffect <> >> div button textarea span input list-> a
            [] respo.css :refer $ [] defstyle
            [] respo.comp.space :refer $ [] =<
            [] reel.comp.reel :refer $ [] comp-reel
            [] respo-md.comp.md :refer $ [] comp-md
            [] app.config :refer $ [] dev? lang
            [] respo-ui.css :as css
            [] memof.once :refer $ [] memof1-call memof1-call-by
            [] |@memkits/azure-speech-util :refer $ [] speechQueue nativeSpeechOne
            [] app.schema :refer $ [] Op
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ option:unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'lang $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def lang
            option:unwrap-or (get-env |lang) |en-US
          :examples $ []
          :schema $ :: 'String
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |lutea-reader
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *reel
            -> reel-schema/reel (assoc :base app.schema/store) (assoc :store app.schema/store)
          :examples $ []
          :schema $ :: 'Ref 'app.schema/Reel
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            reset! *reel $ assert-type (reel-updater updater @*reel op) 'app.schema/Reel
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            add-event-listener! |beforeunload $ fn (_) (persist-storage!)
            set-interval! persist-storage! 60000
            match
              storage-get $ config/site :storage-key
              (:some raw)
                dispatch! $ app.schema/Op :hydrate-storage $ decode-map-as (parse-cirru-edn raw) app.schema/Store
              (:none) &unit
            add-event-listener! |keydown $ fn (event)
              when (toggle-shortcut? event)
                dispatch! $ app.schema/Op :toggle-rendered
              , &unit
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            option:unwrap $ query-selector |.app
          :examples $ []
          :schema $ :: 'js-ffi.browser/DomElementHost
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            storage-set! (config/site :storage-key)
              format-cirru-edn $ decode-map-as (&map:get @*reel :store) app.schema/Store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ assert-type (refresh-reel @*reel app.schema/store updater) 'app.schema/Reel
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'toggle-shortcut? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn toggle-shortcut? (event)
            let
                keyboard $ unsafe-coerce event js-ffi.browser/KeyboardEventHost
              and
                = |e $ keyboard :key
                keyboard :meta-key?
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.browser/EventHost
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            [] respo.core :refer $ [] render! clear-cache!
            [] app.comp.container :refer $ [] comp-container
            [] app.updater :refer $ [] updater
            [] reel.util :refer $ [] listen-devtools!
            [] reel.core :refer $ [] reel-updater refresh-reel
            [] reel.schema :as reel-schema
            [] app.config :as config
            [] |./calcit.build-errors :default build-errors
            [] |bottom-tip :default hud!
            [] js-ffi.browser :refer $ [] query-selector add-event-listener! set-interval! storage-get storage-set!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :content 'String
            :toggle-rendered
            :hydrate-storage 'app.schema/Store
            :reel/toggle
            :reel/recall 'Number
            :reel/run
            :reel/step
            :reel/merge
            :reel/reset
            :reel/remove 'Number
          :examples $ []
          :schema $ :: 'EnumDef
        'Reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def Reel &unit
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Tag 'Dynamic
            :content 'String
            :rendered? 'Bool
          :examples $ []
          :schema $ :: 'StructDef
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states
              {} $ :cursor $ []
              , :content | :rendered? false
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor data)
                decode-map-as (update-states store cursor data) app.schema/Store
              (:content data) (assoc store :content data)
              (:toggle-rendered) (update store :rendered? not)
              (:hydrate-storage data) (decode-map-as data app.schema/Store)
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Enum 'String 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-states
