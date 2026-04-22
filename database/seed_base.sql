INSERT INTO tbl_categorie (nome, tipo) VALUES ('Salute', 'uscita'), ('Sport', 'uscita'), ('Cibo', 'uscita'), ('Moda', 'uscita'), ('Regali', 'uscita'), ('Trasporti Pubblici', 'uscita'), ('Auto\Moto', 'uscita'), ('Abbonamenti', 'uscita'), ('Stipendio', 'ingresso'), ('Bonifico','ingresso'), ('Paghetta', 'ingresso'), ('Investimenti', 'ingresso'), ('Prestiti', 'ingresso'), ('Regali', 'ingresso');

-- TAG CATEGORIA: SALUTE
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Visite', 1), ('Medicine', 1), ('Trattamenti', 1);

-- TAG CATEGORIA SPORT
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Palestra', 2), ('Sport Generale', 2), ('Attrezzatura', 2);

-- TAG CATEGORIA CIBO
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Pranzo', 3), ('Cena', 3), ('Caffe', 3), ('Merenda', 3), ('Spesa', 3);

-- TAG CATEGORIA MODA
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Vestiti', 4), ('Accessori', 4), ('Scarpe', 4);

-- TAG CATEGORIA REGALI
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Varie', 5);

-- TAG CATEGORIA TRASPORTI PUBBLICI
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Taxi', 6), ('Treno', 6), ('Aereo', 6), ('Barca', 6), ('Bus', 6);

-- TAG CATEGORIA AUTO\MOTO
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Ricambi', 7), ('Bollo', 7), ('Assicurazione', 7), ('Meccanico', 7), ('Estetica', 7);

-- TAG CATEGORIA ABBONAMENTI
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Musica', 8), ('Video', 8), ('AI', 8), ('Varie', 8);