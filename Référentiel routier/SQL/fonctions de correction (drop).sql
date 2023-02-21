-- Effacement des fonctions.
drop function if exists LierTroncons(_CleAbs1 character varying, _CleAbs2 character varying, _Extremites character varying, _Fictif boolean);
drop function if exists ModifierSens(_CleAbs character varying, _Sens character varying);
drop function if exists ModifierAltimetrie(_CleAbs character varying, _Z double precision, _SeuilPente integer);
drop function if exists CreerRouteNumeroteeOuNommee(_CleAbs character varying, _TypeDeRoute character varying, _Numero character varying, _Gestionnaire character varying);
drop function if exists ModifierLienVersRouteNumeroteeOuNommee(_CleAbs character varying, _CleAbsRouteNumeroteeOuNommee character varying);