(lang dune 3.4)

(generate_opam_files true)
(package
 (name shazam)
 (allow_empty)
 (synopsis "A logging microservice.")
 (description "A logging microservice with a Java client.")
 (depends 
   ocaml
   dune
   lwt
   core
   ptime
   ppx_deriving_yojson
   yojson
   dream)
 (tags
  (topics Loggin-Microservice)))

(source
 (github devproca/shazam))