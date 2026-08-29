# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "utils/iso_date"
pin "sortablejs" # @1.15.7
pin "hotkeys-js" # @4.0.5
pin "pdfjs-dist" # @4.7.76
pin "pdfjs-dist/build/pdf.worker.mjs", to: "pdfjs-dist--build--pdf.worker.mjs.js", preload: false # @4.7.76
