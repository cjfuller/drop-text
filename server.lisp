(load "~/quicklisp/setup.lisp")

(ql:quickload :ningle)

(defpackage :drop-text
  (:use :cl
        :clack.request))
(in-package :drop-text)

(defun store-data (req)
  (let ((fn (concatenate 'string (write-to-string (get-universal-time)) ".txt")))
    (with-open-file (stream fn :direction :output)
                    (format stream (body-parameter req :|message|))))
    "Data submitted.")

(defun render-form ()
  "<html><body><form action=\"/submit\" method=\"post\"><div style=\"font-family: sans-serif;\"><label for=\"message\">Enter text here:</label></div><textarea name=\"message\" id=\"message\" style=\"min-width: 300px; min-height: 200px;
\"></textarea><button type=\"submit\">Submit</button></form></body></html>")

(defvar *app* (make-instance 'ningle:<app>))

(setf (ningle:route *app* "/")
      (render-form))

(setf (ningle:route *app* "/submit" :method :POST)
      (lambda (stuff)
        (store-data ningle:*request*)))

(clack:clackup *app*
               :port 9002
               :ssl t
               :ssl-key-file "~/.keys/server.key"
               :ssl-cert-file "~/.keys/server.crt"
               :ssl-key-password nil)

