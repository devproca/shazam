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
   ptime
   dream
   cmdliner
   caqti
   caqti-lwt
   caqti-driver-sqlite3)
 (tags
  (topics Loggin-Microservice)))

(source
 (github devproca/shazam))