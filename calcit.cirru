
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/
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
                store $ :store reel
                states store.:states
              div
                {} $ :style $ .merge ui/global ui/fullscreen ui/row
                div
                  {} $ :style $ .merge ui/expand ui/row
                  if store.:rendered? (comp-reader-ui store.:content)
                    textarea $ {} (:value store.:content) (:autofocus true) (:placeholder "|Paste text here, then hit \"Toggle\" button...")
                      :style $ .merge ui/expand ui/textarea $ {}
                        :border $ str "|1px solid " $ hsl 0 0 94
                        :padding "|40px 80px"
                        :background-color $ hsl 0 0 94
                      :on-input $ fn (e d!)
                        hint-fn $ {} (:return 'Unit)
                          :args $ [] (:: 'Map 'Tag 'Dynamic)
                            :: 'Fn $ {} (:rest 'Dynamic) (:return 'Unit)
                              :args $ [] 'Dynamic
                        d! $ Op :content $ event-value e
                a $ {}
                  :class-name $ str-spaced css/link css-toggle
                  :inner-text |Toggle
                  :on-click $ fn (e d!)
                    hint-fn $ {} (:return 'Unit)
                      :args $ [] (:: 'Map 'Tag 'Dynamic)
                        :: 'Fn $ {} (:rest 'Dynamic) (:return 'Unit)
                          :args $ [] 'Dynamic
                    d! $ Op :toggle-rendered
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'Enum 'app.schema/Store
            :features $ #{} :js-ffi
        'comp-paragraph-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-paragraph-ui (p)
            let
                words $ -> (split-regex p pattern-spaces)
                  filter $ fn (word)
                    not $ blank? word
              div
                {} (:class-name css-paragraph) (:tab-index 0)
                list-> ({})
                  -> (join words "| ")
                    map-indexed $ fn (j word)
                      [] j $ if (= word "| ") (<> "| ") (comp-word-ui word)
                a $ {} (:inner-text |Speech)
                  :class-name $ str-spaced css/link css-speech-button
                  :on-click $ fn (e d!)
                    hint-fn $ {} (:return 'Unit)
                      :args $ [] (:: 'Map 'Tag 'Dynamic)
                        :: 'Fn $ {} (:rest 'Dynamic) (:return 'Unit)
                          :args $ [] 'Dynamic
                    speak-text! p lang
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'comp-reader-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-reader-ui (content)
            let
                paragraphs $ -> (split-regex content pattern-lines)
                  filter $ fn (paragraph)
                    not $ blank? paragraph
              div
                {} $ :style $ .merge ui/expand
                  {} $ :background-color $ hsl 0 0 92
                list->
                  {} $ :class-name css-content-area
                  -> paragraphs $ map-indexed $ fn (idx paragraph)
                    [] idx $ memo-comp-by idx comp-paragraph-ui paragraph
                =< &unit |40vh
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'comp-word-ui $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-word-ui (word)
            let
                chars $ split word |
                len $ .len word
              list->
                {} $ :style $ {} (:display |inline-block)
                map-indexed chars $ fn (idx char)
                  [] idx $ <> char $ {}
                    :color $ hsl 0 0 $ +
                      &max 0 $ - 50 $ * 5 len
                      * 50 $ pow (/ idx len) 1.2
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
            :features $ #{} :js-ffi
        'css-content-area $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-content-area
            {} $ |$0 $ {} (:font-family ui/font-normal) (:font-size |16px) (:padding "|40px 80px") (:max-width |960px) (:margin "|0 auto")
          :examples $ []
          :schema $ :: 'String
        'css-paragraph $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-paragraph
            {}
              |$0 $ {} (:padding "|30px 30px") (:transition-duration |280ms) (:position |relative) (:border-radius |0px)
                :background-color $ hsl 190 0 92
                :border $ str "|2px solid " $ hsl 0 0 90
                :border-top-width |1px
                :border-bottom-width |1px
                :border-left $ str "|2px solid " $ hsl 0 0 90
              |$0:hover $ {}
                :border-left-color $ hsl 190 20 96
                :background-color $ hsl 190 0 95
              |$0:focus $ {}
                :background-color $ hsl 190 0 100
                :border-left $ str "|2px solid " $ hsl 0 0 100
                :box-shadow $ str "|0 0 6px " $ hsl 0 0 0 (Option :some 0.2)
                :z-index |101
                :border-radius |4px
          :examples $ []
          :schema $ :: 'String
        'css-speech-button $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-speech-button
            {} $ |$0 $ {} (:position |absolute) (:right |4px) (:bottom |4px) (:font-size |13px) (:font-family ui/font-fancy)
          :examples $ []
          :schema $ :: 'String
        'css-toggle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-toggle
            {} $ |$0 $ {} (:position |fixed) (:top |20px) (:right |20px)
          :examples $ []
          :schema $ :: 'String
        'event-value $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn event-value (event)
            decode-map-as
              .unwrap $ get event :value
              , 'String
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
            :features $ #{} :js-ffi
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
            decode-map-as
              to-calcit-data
                .split-regex (unsafe-coerce text StringHost) pattern
                , true
              :: 'List 'String
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String 'app.comp.container/RegexHost
            :features $ #{} :js-ffi
            :return $ :: 'List 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp <> >> div textarea list-> a memo-comp-by
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev? lang
            respo-ui.css :as css
            |@memkits/azure-speech-util :refer $ speechQueue nativeSpeechOne
            app.schema :refer $ Op
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'lang $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def lang
            .unwrap-or (get-env |lang) |en-US
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
          :code $ quote $ defref *reel (typed/new-reel app.schema/store)
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'Enum 'app.schema/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            if (enum? op)
              do
                when config/dev? $ println |Dispatch: op
                match (typed/decode-control op)
                  (:some control)
                    reset! *reel $ typed/apply-control updater @*reel control
                  (:none)
                    reset! *reel $ typed/record-op updater @*reel op (generate-id!) (host/now-ms)
                , &unit
              raise |Expected-Enum-operation
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            match
              storage-get $ .unwrap $ get config/site :storage-key
              (:some raw)
                dispatch! $ app.schema/Op :hydrate-storage $ app.schema/decode-store (parse-cirru-edn raw)
              (:none) &unit
            render-app!
            add-watch! *reel :changes $ fn (reel prev)
              hint-fn $ {} (:return 'Unit)
                :args $ [] (:: 'reel.typed/State 'Enum 'app.schema/Store) (:: 'reel.typed/State 'Enum 'app.schema/Store)
              render-app!
            listen-devtools! |k dispatch!
            add-event-listener! |beforeunload $ fn (_)
              hint-fn $ {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
              persist-storage!
            set-interval! persist-storage! 60000
            add-event-listener! |keydown $ fn (event)
              hint-fn $ {} (:return 'Unit)
                :args $ [] 'js-ffi.browser/EventHost
              when
                toggle-shortcut? $ keyboard-event-host event
                dispatch! $ app.schema/Op :toggle-rendered
              , &unit
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ dom/query-selector |.app
          :examples $ []
          :schema $ :: 'respo.dom/DomElement
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            storage-set!
              .unwrap $ get config/site :storage-key
              format-cirru-edn $ &struct:to-map $ :store @*reel
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                add-watch! *reel :changes $ fn (reel prev)
                  hint-fn $ {} (:return 'Unit)
                    :args $ [] (:: 'reel.typed/State 'Enum 'app.schema/Store) (:: 'reel.typed/State 'Enum 'app.schema/Store)
                  render-app!
                reset! *reel $ typed/refresh updater @*reel app.schema/store
                hud! |ok~ |Ok
                , &unit
              do (hud! |error build-errors) &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel
              , dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'toggle-shortcut? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn toggle-shortcut? (event)
            and
              = |e $ event :key
              event :meta-key?
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'js-ffi.browser/KeyboardEventHost
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            reel.util :refer $ listen-devtools!
            reel.typed :as typed
            js-ffi.shared :as host
            respo.ffi.browser :as dom
            app.config :as config
            |./calcit.build-errors.mjs :default build-errors
            |bottom-tip :default hud!
            js-ffi.browser :refer $ add-event-listener! set-interval! storage-get storage-set! keyboard-event-host
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
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Dynamic 'Dynamic
            :content 'String
            :rendered? 'Bool
          :examples $ []
          :schema $ :: 'StructDef
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (raw)
            if (struct? raw)
              decode-map-as (&struct:to-map raw) app.schema/Store
              decode-map-as raw app.schema/Store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'Dynamic
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
                assoc store :states $ decode-map-as
                  update-state-tree (:states store)
                    decode-map-as cursor $ :: 'List 'Dynamic
                    , data
                  :: 'Map 'Dynamic 'Dynamic
              (:content data)
                assoc store :content $ decode-map-as data 'String
              (:toggle-rendered) (update store :rendered? not)
              (:hydrate-storage data) (app.schema/decode-store data)
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Enum 'String 'Number
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require
            respo.cursor :refer $ update-state-tree
            app.schema :as schema
