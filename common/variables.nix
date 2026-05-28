{ machine, vars }:

let
  all-variables = { inherit machine vars; };
in

{
  _module.args = all-variables;
}
