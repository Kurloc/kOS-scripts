// EXAMPLE OF HOW TO MIMICK A NAMESPACE ALSO MANAGES IMPORTS
// I think this will technically also lazy load the dependencies, but I probably should add some if check, not sure if they cache the RUN behind the scenes?
GLOBAL PROGRAMS IS LEX(
    "OSPREY", LEX(
        "MAIN", {
            RUN "0:/programs/osprey/main.ks".
            return main.
        }
    )
).