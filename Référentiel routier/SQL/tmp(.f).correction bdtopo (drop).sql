-- Effacement des fonctions.
drop function if exists ModifierNumeroRoute(_IdIGN character varying, _NumeroRoute character varying);
drop function if exists ModifierAltimetrie(_IdIGN character varying, _Z double precision, _SeuilPente integer);
drop function if exists ModifierSens(_IdIGN character varying, _Sens character varying);
drop function if exists MettreEnGestionCommunale(_IdIGN character varying);
drop function if exists MettreEnGestionDepartementale(_IdIGN character varying, _NumeroRoute character varying, _Gestion character varying);
drop function if exists MettreEnGestionNationale(_IdIGN character varying, _NumeroRoute character varying, _Gestion character varying);
drop function if exists ModifierGestionnaire(_IdIGN character varying, _NumeroRoute character varying, _ClasseAdmin character varying, _Gestion character varying);