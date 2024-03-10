/* 
  basisstandaard om stapel van 3U 19 inch kasten te kantelen.
  Deze standaard is bedoeld voor rack 2 en is gemodelleerd op de houten
  standaard van rack 1.
  
*/
  
$fn = 150;
  
inkepinghoogte = 20;
rack_breedte = 132;
rack_hoogte = 240;

xpos_inkeping = 186;
angle = 39.25;

voorkant_hoogte = 172;
materiaal_dikte = 15;

balkbreedte = 40;
balkhoogte = inkepinghoogte;

bufferblok_lengte = 50;
bufferblok_breedte = 30;

// schroeven voor boorgaten voor houten balk tussen geprinte rechterdelen.
verbindingsbalkschroef_diameter = 4.5;

// schroeven voor boorgaten om de beide delen van de standaard linker_deel_3d en rechter_deel_3d met elkaar te verbinden.
verbindingsschroeven_diameter = 3.5;

// schroeven voor boorgaten voor houten balk tussen geprinte steunen.
voorkant_schroeven_diameter = 4.5;


module linker_deel() {
    difference() {
        square([xpos_inkeping, voorkant_hoogte]);  
        // 19 inch kast
        translate([xpos_inkeping, inkepinghoogte, 0]) {
            rotate([0, 0, 90 - angle]) {
                square([rack_breedte, rack_hoogte]);
            }
        }
    }
}

module linker_wandgat() {
    scale([0.6, 0.6, 1]) linear_extrude(materiaal_dikte) linker_deel();
}

// boorgaten voor houten balk tussen geprinte rechterdelen.
verbindingsbalkschroef_radius = verbindingsbalkschroef_diameter / 2;
module bufferblok_boorgaten() {
    translate([bufferblok_lengte * 1 / 3, 3 * bufferblok_breedte / 4, 0]) circle(verbindingsbalkschroef_radius);
    translate([bufferblok_lengte * 2 / 3, 3 * bufferblok_breedte / 4, 0]) circle(verbindingsbalkschroef_radius);
}

module bufferblok() {
    difference() {
        square([bufferblok_lengte, bufferblok_breedte]);
        #bufferblok_boorgaten();
    }    
}

module _rechter_deel1() {
    // bedoeld voor opening / gat in rechterdeel door rechterdeel te schalen.
    translate([xpos_inkeping - cos(angle) * inkepinghoogte, 0, 0]) {
        rotate([0, 0, -angle]) {
            square([rack_hoogte, rack_breedte + (2 - cos(angle)) * inkepinghoogte]);
        }
    }
}

module _rechter_deel2() {
    // verlengstuk voor wig van 2e 19 inch kast met boorgaten
    translate([xpos_inkeping - cos(angle) * inkepinghoogte, 0, 0]) {
        rotate([0, 0, -angle]) {
            square([rack_hoogte, rack_breedte + (2 - cos(angle)) * inkepinghoogte]);
            translate([0, 140]) color([1, 1, 1]) bufferblok();
        }
    }
}

module wissen() {
    rotate([-180]) translate([0, 0, 0]) square([2 * rack_hoogte, voorkant_hoogte]);
}

module rechter_deel1() {
    // bedoeld om te schalen, dus zonder verlengstuk voor wig van 2e 19 inch kast
    difference() {
        _rechter_deel1();
        wissen();
    }
}

module rechter_deel2() {
    difference() {
        _rechter_deel2();
        wissen();
    }
}

module rechter_wandgat() {
    scale([0.6, 0.6, 1]) linear_extrude(materiaal_dikte) rechter_deel1();
}

module negatieve_verbindingsbalk_3d() {
    linear_extrude(materiaal_dikte) {
        translate([xpos_inkeping - balkbreedte, 0, 0]) {
            square([balkbreedte * 2, balkhoogte]);
        }   
    }
}

// boorgaten om de beide delen van de standaard linker_deel_3d en rechter_deel_3d met elkaar te verbinden.
verbindingsschroeven_radius = verbindingsschroeven_diameter / 2;
module boorgaten() {
    translate([balkbreedte * 1 / 4, inkepinghoogte / 2, 0]) cylinder(materiaal_dikte, verbindingsschroeven_radius, verbindingsschroeven_radius);
    translate([balkbreedte, inkepinghoogte / 2, 0]) cylinder(materiaal_dikte, verbindingsschroeven_radius, verbindingsschroeven_radius);
    translate([balkbreedte * 1.75, inkepinghoogte / 2, 0]) cylinder(materiaal_dikte, verbindingsschroeven_radius, verbindingsschroeven_radius);
}

voorkant_schroeven_radius = voorkant_schroeven_diameter / 2;
// boorgaten voor houten balk tussen geprinte steunen
module boorgaten_voorkant() {
    translate([materiaal_dikte * 2 / 5, materiaal_dikte / 2, 0]) cylinder(materiaal_dikte, voorkant_schroeven_radius, voorkant_schroeven_radius);
    translate([materiaal_dikte * 2 / 5, 3 * materiaal_dikte / 2, 0]) cylinder(materiaal_dikte, voorkant_schroeven_radius, voorkant_schroeven_radius);
}

module verbindingsbalk_3d() {
    difference() {
        difference() {
            linear_extrude(materiaal_dikte / 2) {
                translate([xpos_inkeping - balkbreedte, 0, 0]) {
                    square([balkbreedte * 2, balkhoogte]);
                }   
            }
        }
        // Boorgaten voor houten latten die de 2 steunen bij elkaar houden.
        translate([xpos_inkeping - balkbreedte, 0, 0]) boorgaten();
    }
}


letterdikte = 3;
lettergrootte = 9;
module linkertekst() {
    xoffset = 20;
    yoffset = lettergrootte / 4;
    translate([xoffset, yoffset, materiaal_dikte - letterdikte]) linear_extrude(letterdikte) text("Tilt-O-Matic", size=lettergrootte);
}


module linker_deel_3d() {
    difference() {
        linear_extrude(materiaal_dikte) linker_deel();
        negatieve_verbindingsbalk_3d();
        translate([rack_hoogte / 15, rack_breedte / 10, 0]) linker_wandgat();
        boorgaten_voorkant();       
        linkertekst();
    }
    verbindingsbalk_3d();

}

module _rechter_deel_3d() {
    difference() {
        linear_extrude(materiaal_dikte) rechter_deel2();
        translate([0, 0, 0]) negatieve_verbindingsbalk_3d();
        translate([xpos_inkeping / 2 + rack_hoogte / 10, rack_breedte / 10, 0]) rechter_wandgat();        
    }
    translate([0, 0, materiaal_dikte / 2]) verbindingsbalk_3d();
}

module inkorten() {
    // Haal punt in rechter deel weg om dat niet te lang te maken.
    xpos = xpos_inkeping + 195;
    translate([xpos, 0, 0]) linear_extrude(materiaal_dikte) square([50, 40]);
}

module rechter_deel_3d() {
    difference() {
        _rechter_deel_3d();
        inkorten();
    }
}

module alles(a = 0, b = 0) {
    if (a == 1) {
        linker_deel_3d();
    }
    if (b == 1) {
        translate([0, 0, materiaal_dikte * 3]) rechter_deel_3d();
    }
}


alles(1, 1);
