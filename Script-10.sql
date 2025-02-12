# Tabela dom
 
CREATE OR REPLACE TABLE dom (
    id_domu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_domu VARCHAR(50) UNIQUE,
    adres VARCHAR(100),
    liczba_uzytkownikow INT
);
 
INSERT INTO dom (nazwa_domu, adres, liczba_uzytkownikow) VALUES
('Sportowcy', 'Miodowa 16', 3),
('Biolodzy', 'Karmelowa 34', 5),
('Matematycy', 'Kwiatowa 24', 4),
('Artyści', 'Starorzecze 42', 2),
('Zwariowani', 'Kasztanowa 17', 4),
('Golebiarze', 'Ptasia 3', 3);
 
SELECT * FROM dom;
 
# Tabela domownicy
 
CREATE OR REPLACE TABLE domownicy (
    id_uzytkownika INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    id_domu INT,
    nazwa_domu VARCHAR(50),
    haslo VARCHAR(50),
    CONSTRAINT fk_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu)
);
 
INSERT INTO domownicy (imie, nazwisko, nazwa_domu, haslo) VALUES
-- Dom "Sportowcy"
('Adam', 'Jabłoński', '', 'aA1rD3z8'),
('Ewa', 'Jabłońska', '', 'rT2wE5yL'),
('Kamil', 'Jabłoński', '', '9cXkH4m2'),
 
-- Dom "Biolodzy"
('Anna', 'Wiśniewska', '', 'qP7vF2zB'),
('Piotr', 'Wiśniewski', '', 'oL4pT1mH'),
('Julia', 'Wiśniewska', '', 'aJ2gL5mC'),
('Oliwia', 'Wiśniewska', '', 'zX8pQ3yW'),
('Mateusz', 'Wiśniewski', '', 'tR2xU9vF'),
 
-- Dom "Matematycy"
('Jan', 'Dąbrowski', '', 'vD3kT9mB'),
('Maria', 'Dąbrowska', '', 'nC5hS2oQ'),
('Tomasz', 'Dąbrowski', '', 'wZ7fK1yP'),
('Natalia', 'Dąbrowska', '', 'xU4sP2iV'),
 
-- Dom "Artyści"
('Artur', 'Lewandowski', '', 'gR8mE1aJ'),
('Magdalena', 'Lewandowska', '', 'jW3vB9nA'),
 
-- Dom "Zwariowani"
('Karol', 'Nowicki', '', 'tQ4wF8lX'),
('Joanna', 'Nowicka', '', 'pK2nA5rV'),
('Zofia', 'Nowicka', '', 'hD6yJ1eP'),
('Michał', 'Nowicki', '', 'oL7uZ9tN'),
 
-- Dom "Gołębiarze"
('Paweł', 'Mazur', '', 'cT8qX5mV'),
('Katarzyna', 'Mazur', '', 'pM2vL9yR'),
('Tomasz', 'Mazur', '', 'eS4nQ3jF');
 
SET @index = 0;
 
UPDATE domownicy d
JOIN (
    SELECT id_domu, nazwa_domu, liczba_uzytkownikow,
           @index := @index + liczba_uzytkownikow AS end_index,
           @index - liczba_uzytkownikow + 1 AS start_index
    FROM dom
) domy
ON d.id_uzytkownika BETWEEN domy.start_index AND domy.end_index
SET d.nazwa_domu = domy.nazwa_domu
WHERE d.nazwa_domu IS NULL OR d.nazwa_domu = '';
 
SELECT * FROM domownicy;
 
CREATE OR REPLACE FUNCTION generate_nazwa_uzytkownika(imie VARCHAR(50), nazwisko VARCHAR(50))
RETURNS VARCHAR(50)
BEGIN
    DECLARE unique_username VARCHAR(50);
    DECLARE random_suffix INT;
    DECLARE is_unique INT;
 
    REPEAT
        SET random_suffix = FLOOR(RAND() * 900) + 100;
        SET unique_username = CONCAT(LOWER(imie), '.', LOWER(nazwisko), random_suffix);
 
        SELECT COUNT(*) INTO is_unique
        FROM domownicy
        WHERE nazwa_uzytkownika = unique_username;
 
    UNTIL is_unique = 0
    END REPEAT;
 
    RETURN unique_username;
END;
 
ALTER TABLE domownicy
ADD COLUMN nazwa_uzytkownika VARCHAR(50);
 
ALTER TABLE domownicy
ADD CONSTRAINT UNIQUE (nazwa_uzytkownika);
 
UPDATE domownicy
SET nazwa_uzytkownika = generate_nazwa_uzytkownika(imie, nazwisko)
WHERE nazwa_uzytkownika IS NULL;
 
UPDATE domownicy d
JOIN dom domy
ON d.nazwa_domu = domy.nazwa_domu
SET d.id_domu = domy.id_domu
WHERE d.id_domu IS NULL;
 
SELECT * FROM domownicy;
 
# Tabela kategorie
 
CREATE OR REPLACE TABLE kategorie (
	id_kategorii INT AUTO_INCREMENT PRIMARY KEY,
	nazwa_kategorii VARCHAR(50),
	opis VARCHAR(300),
	typ ENUM('dochód', 'wydatek')
);
 
INSERT INTO kategorie (nazwa_kategorii, opis, typ) VALUES
('Technologia', 'Produkty związane z nowoczesną technologią, sprzętem elektronicznym', 'wydatek'),
('Rozrywka', 'Kategoria dotycząca książek, filmów, sztuki i wydarzeń rozrywkowych', 'wydatek'),
('Odzież', 'Produkty odzieżowe, w tym ubrania, buty i dodatki', 'wydatek'),
('Spożywcze', 'Produkty spożywcze, w tym żywność i napoje', 'wydatek'),
('Dom i ogród', 'Produkty związane z wyposażeniem domu i ogrodu', 'wydatek'),
('Motoryzacja', 'Części samochodowe i akcesoria motoryzacyjne', 'wydatek'),
('Zdrowie', 'Produkty związane ze zdrowiem, w tym suplementy, leki i urządzenia medyczne', 'wydatek'),
('Opłaty stałe', 'Kategorie obejmujące regularne opłaty, takie jak rachunki za prąd, wodę, internet', 'wydatek'),
('Prezenty', 'Produkty, które mogą być używane jako prezenty na różne okazje', 'wydatek'),
('Trening', 'Produkty związane z treningiem i aktywnością fizyczną', 'wydatek'),
('Transport', 'Produkty i usługi związane z transportem, takie jak bilety, paliwo, ubezpieczenia', 'wydatek'),
('Inne', 'Różne produkty, które nie pasują do innych kategorii', 'wydatek'),
('Restauracje', 'Produkty i usługi związane z jedzeniem w restauracjach i cateringiem', 'wydatek'),
('Podróże', 'Produkty i usługi związane z turystyką i podróżami', 'wydatek'),
('Higiena', 'Produkty związane z higieną osobistą, w tym kosmetyki, środki czystości', 'wydatek'),
('Wynagrodzenie', 'Dochód uzyskiwany z tytułu pracy zawodowej', 'dochód'),
('Premia', 'Dodatkowy dochód wypłacany za wyniki pracy lub okoliczności specjalne', 'dochód'),
('Kieszonkowe', 'Drobna kwota pieniędzy przekazywana na wydatki osobiste', 'dochód'),
('Inwestycje', 'Dochód uzyskany z inwestowania, np. w akcje, nieruchomości, obligacje', 'dochód'),
('Dodatkowe zarobki', 'Dochód uzyskany z dodatkowej działalności zawodowej poza głównym zatrudnieniem', 'dochód');
 
SELECT * FROM kategorie;
 
# Widok wydatków
 
CREATE OR REPLACE VIEW widok_wydatki AS
SELECT
    id_kategorii,
    nazwa_kategorii,
    opis
FROM
    kategorie
WHERE
    typ = 'wydatek';
   
SELECT * FROM widok_wydatki;
   
# Widok dochodów
   
CREATE OR REPLACE VIEW widok_dochody AS
SELECT
    id_kategorii,
    nazwa_kategorii,
    opis
FROM
    kategorie
WHERE
    typ = 'dochód';
   
SELECT * FROM widok_dochody;
 
# Tabela dochodów
 
CREATE OR REPLACE TABLE dochod (
    id_dochodu INT AUTO_INCREMENT PRIMARY KEY,
    id_uzytkownika INT,
    nazwa_uzytkownika VARCHAR(50),
    id_domu INT,
    nazwa_domu VARCHAR(50),
    wartosc_dochodu INT,
    id_kategorii INT,
    kategoria_dochodu VARCHAR(50),
    data_dochodu DATE,
    CONSTRAINT fk_dochod_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu),
    CONSTRAINT fk_dochod_id_uzytkownika FOREIGN KEY (id_uzytkownika) REFERENCES domownicy(id_uzytkownika),
    CONSTRAINT fk_dochod_id_kategorii FOREIGN KEY (id_kategorii) REFERENCES kategorie(id_kategorii)
);
 
INSERT INTO dochod (nazwa_uzytkownika, nazwa_domu, wartosc_dochodu, kategoria_dochodu, data_dochodu, id_domu, id_uzytkownika, id_kategorii)
SELECT
    d.nazwa_uzytkownika,
    d.nazwa_domu,
    CASE
        WHEN k.nazwa_kategorii = 'Wynagrodzenie' THEN FLOOR(RAND() * (10000 - 3000 + 1) + 3000)
        ELSE FLOOR(RAND() * (2000 - 500 + 1) + 500)
    END AS wartosc_dochodu,
    k.nazwa_kategorii AS kategoria_dochodu,
    DATE_ADD(CONCAT('2024-', LPAD(m.miesiac, 2, '0'), '-01'), INTERVAL FLOOR(RAND() * 30) DAY) AS data_dochodu,
    dom.id_domu,
    uzytkownik.id_uzytkownika,
    k.id_kategorii
FROM domownicy d
JOIN kategorie k
    ON k.typ = 'dochód'
JOIN dom
    ON dom.nazwa_domu = d.nazwa_domu
JOIN domownicy uzytkownik
    ON uzytkownik.nazwa_uzytkownika = d.nazwa_uzytkownika
JOIN (
    SELECT 1 AS miesiac UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6 UNION ALL
    SELECT 7 UNION ALL
    SELECT 8 UNION ALL
    SELECT 9 UNION ALL
    SELECT 10 UNION ALL
    SELECT 11 UNION ALL
    SELECT 12
) m
WHERE NOT EXISTS (
    SELECT 1
    FROM dochod d2
    WHERE d2.nazwa_uzytkownika = d.nazwa_uzytkownika
    AND d2.nazwa_domu = d.nazwa_domu
    AND d2.kategoria_dochodu = k.nazwa_kategorii
    AND YEAR(d2.data_dochodu) = 2024
    AND MONTH(d2.data_dochodu) = m.miesiac
)
ORDER BY d.nazwa_domu, d.nazwa_uzytkownika, data_dochodu;
 
SELECT * FROM dochod;
 
SELECT
    d.nazwa_domu,
    d.nazwa_uzytkownika,
    dochod.wartosc_dochodu,
    dochod.kategoria_dochodu,
    dochod.data_dochodu
FROM dochod
JOIN domownicy d ON dochod.nazwa_uzytkownika = d.nazwa_uzytkownika
ORDER BY d.nazwa_domu, d.nazwa_uzytkownika, dochod.data_dochodu;
 
SELECT * FROM dochod;

# Widok dochodów miesiąca grudnia
 
CREATE OR REPLACE VIEW widok_grudzien_dochody AS
SELECT
    d.nazwa_domu,
    d.nazwa_uzytkownika,
    dochod.wartosc_dochodu,
    dochod.kategoria_dochodu,
    dochod.data_dochodu
FROM dochod
JOIN domownicy d ON dochod.nazwa_uzytkownika = d.nazwa_uzytkownika
WHERE MONTH(dochod.data_dochodu) = 12
ORDER BY d.nazwa_domu, d.nazwa_uzytkownika, dochod.data_dochodu;

SELECT * FROM widok_grudzien_dochody;

# Tabela wydatki
 
CREATE OR REPLACE TABLE wydatki (
    id_wydatku INT AUTO_INCREMENT PRIMARY KEY,
    id_uzytkownika INT,
    nazwa_uzytkownika VARCHAR(50),
    id_domu INT,
    nazwa_domu VARCHAR(50),
    wartosc_wydatku INT,
    id_kategorii INT,
    kategoria_wydatku VARCHAR(50),
    data_wydatku DATE,
    CONSTRAINT fk_wydatek_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu),
    CONSTRAINT fk_wydatek_id_uzytkownika FOREIGN KEY (id_uzytkownika) REFERENCES domownicy(id_uzytkownika),
    CONSTRAINT fk_wydatek_id_kategorii FOREIGN KEY (id_kategorii) REFERENCES kategorie(id_kategorii)
);
 
INSERT INTO wydatki (nazwa_uzytkownika, nazwa_domu, wartosc_wydatku, kategoria_wydatku, data_wydatku, id_domu, id_uzytkownika, id_kategorii)
SELECT
    d.nazwa_uzytkownika,
    d.nazwa_domu,
    CASE
        WHEN k.nazwa_kategorii = 'Opłaty stałe' THEN FLOOR(RAND() * (4000 - 1000 + 1) + 1000)
        ELSE FLOOR(RAND() * (900 - 100 + 1) + 100)
    END AS wartosc_wydatku,
    k.nazwa_kategorii AS kategoria_wydatku,
    DATE_ADD(CONCAT('2024-', LPAD(m.miesiac, 2, '0'), '-01'), INTERVAL FLOOR(RAND() * 30) DAY) AS data_wydatku,
    dom.id_domu,                       
    uzytkownik.id_uzytkownika,         
    k.id_kategorii                     
FROM domownicy d
JOIN kategorie k
    ON k.typ = 'wydatek'
JOIN dom
    ON dom.nazwa_domu = d.nazwa_domu    
JOIN domownicy uzytkownik
    ON uzytkownik.nazwa_uzytkownika = d.nazwa_uzytkownika  
JOIN (
    SELECT 1 AS miesiac UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6 UNION ALL
    SELECT 7 UNION ALL
    SELECT 8 UNION ALL
    SELECT 9 UNION ALL
    SELECT 10 UNION ALL
    SELECT 11 UNION ALL
    SELECT 12
) m
WHERE NOT EXISTS (
    SELECT 1
    FROM wydatki w
    WHERE w.nazwa_uzytkownika = d.nazwa_uzytkownika
    AND w.nazwa_domu = d.nazwa_domu
    AND w.kategoria_wydatku = k.nazwa_kategorii
    AND YEAR(w.data_wydatku) = 2024
    AND MONTH(w.data_wydatku) = m.miesiac
)
ORDER BY d.nazwa_domu, d.nazwa_uzytkownika, data_wydatku;
 
SELECT
    d.nazwa_domu,
    d.nazwa_uzytkownika,
    wydatki.wartosc_wydatku,
    wydatki.kategoria_wydatku,
    wydatki.data_wydatku
FROM wydatki
JOIN domownicy d ON wydatki.nazwa_uzytkownika = d.nazwa_uzytkownika
ORDER BY d.nazwa_domu, d.nazwa_uzytkownika, wydatki.data_wydatku;
 
SELECT * FROM wydatki;
 
# Widok wydatków miesiąca grudnia
 
CREATE OR REPLACE VIEW widok_grudzien_wydatki AS
SELECT
    d.nazwa_domu,
    d.nazwa_uzytkownika,
    wydatki.wartosc_wydatku,
    wydatki.kategoria_wydatku,
    wydatki.data_wydatku
FROM wydatki
JOIN domownicy d ON wydatki.nazwa_uzytkownika = d.nazwa_uzytkownika
WHERE MONTH(wydatki.data_wydatku) = 12
ORDER BY d.nazwa_domu, d.nazwa_uzytkownika, wydatki.data_wydatku;
 
SELECT * FROM widok_grudzien_wydatki;
 
# Tabela oszczędności domów
 
CREATE OR REPLACE TABLE oszczednosci_domy (
	id_oszczednosci_domy INT AUTO_INCREMENT PRIMARY KEY,
	id_domu INT,
    nazwa_domu VARCHAR(50),
    miesiac INT,
    suma_dochodow INT,
    suma_wydatkow INT,
    oszczednosci INT,
    CONSTRAINT fk_oszczednosci_domy_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu)
);
 
ALTER TABLE oszczednosci_domy
ADD UNIQUE (nazwa_domu, miesiac);
 
# Procedura sumowania dochodów
 
CREATE OR REPLACE PROCEDURE Sumuj_Dochody()
BEGIN
    INSERT INTO oszczednosci_domy (nazwa_domu, miesiac, suma_dochodow)
    SELECT nazwa_domu, MONTH(data_dochodu) AS miesiac, SUM(wartosc_dochodu)
    FROM dochod
    GROUP BY nazwa_domu, MONTH(data_dochodu)
    ON DUPLICATE KEY UPDATE suma_dochodow = VALUES(suma_dochodow);
END;
 
# Procedura sumowania wydatków
 
CREATE OR REPLACE PROCEDURE Sumuj_Wydatki()
BEGIN
    INSERT INTO oszczednosci_domy (nazwa_domu, miesiac, suma_wydatkow)
    SELECT nazwa_domu, MONTH(data_wydatku) AS miesiac, SUM(wartosc_wydatku)
    FROM wydatki
    GROUP BY nazwa_domu, MONTH(data_wydatku)
    ON DUPLICATE KEY UPDATE suma_wydatkow = VALUES(suma_wydatkow);
END;
 
# Procedura obliczania oszczedności
 
CREATE OR REPLACE PROCEDURE Oblicz_Oszczednosci()
BEGIN
    UPDATE oszczednosci_domy
    SET oszczednosci = suma_dochodow - suma_wydatkow
    WHERE suma_dochodow IS NOT NULL AND suma_wydatkow IS NOT NULL;
END;
 
# Procedura wykonanie procedur
 
CREATE OR REPLACE PROCEDURE Wykonaj_Oszczednosci()
BEGIN
	
    CALL Sumuj_Dochody();
 
    CALL Sumuj_Wydatki();
 
    CALL Oblicz_Oszczednosci();
END;
 
CALL Wykonaj_Oszczednosci();
 
UPDATE oszczednosci_domy o
JOIN dom d ON o.nazwa_domu = d.nazwa_domu
SET o.id_domu = d.id_domu
WHERE o.id_domu IS NULL;
 
SELECT * FROM oszczednosci_domy;
 
# Tabela budżetu
 
CREATE OR REPLACE TABLE budzet (
    id_budzetu INT AUTO_INCREMENT PRIMARY KEY,
    id_uzytkownika INT,
    nazwa_uzytkownika VARCHAR(50),
    id_domu INT,
    nazwa_domu VARCHAR(50),
    suma_dochodow INT,
    suma_wydatkow INT,
    zaoszczedzona_kwota INT,
    CONSTRAINT fk_budzet_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu),
    CONSTRAINT fk_budzet_id_uzytkownika FOREIGN KEY (id_uzytkownika) REFERENCES domownicy(id_uzytkownika)
);
 
INSERT INTO budzet (nazwa_uzytkownika, nazwa_domu)
SELECT DISTINCT nazwa_uzytkownika, nazwa_domu
FROM domownicy;
 
# Procedura zliczająca sumę dochodów
 
CREATE OR REPLACE PROCEDURE zlicz_dochody_do_budzetu()
BEGIN
    UPDATE budzet AS budzet_uzytkownika
    JOIN (
        SELECT nazwa_uzytkownika, nazwa_domu, SUM(wartosc_dochodu) AS suma_dochodow
        FROM dochod
        GROUP BY nazwa_uzytkownika, nazwa_domu
    ) AS dochody_uzytkownika
    ON budzet_uzytkownika.nazwa_uzytkownika = dochody_uzytkownika.nazwa_uzytkownika
       AND budzet_uzytkownika.nazwa_domu = dochody_uzytkownika.nazwa_domu
    SET budzet_uzytkownika.suma_dochodow = dochody_uzytkownika.suma_dochodow;
END;
 
# Procedura zliczająca sumę wydatków
 
CREATE OR REPLACE PROCEDURE zlicz_wydatki_do_budzetu()
BEGIN
        UPDATE budzet AS budzet_uzytkownika
    JOIN (
        SELECT nazwa_uzytkownika, nazwa_domu, SUM(wartosc_wydatku) AS suma_wydatkow
        FROM wydatki
        GROUP BY nazwa_uzytkownika, nazwa_domu
    ) AS wydatki_uzytkownika
    ON budzet_uzytkownika.nazwa_uzytkownika = wydatki_uzytkownika.nazwa_uzytkownika
       AND budzet_uzytkownika.nazwa_domu = wydatki_uzytkownika.nazwa_domu
    SET budzet_uzytkownika.suma_wydatkow = wydatki_uzytkownika.suma_wydatkow;
END;
 
# Procedura obliczająca (różnicę) sumy dochodów i sumy wydatków
 
CREATE OR REPLACE PROCEDURE aktualizuj_zaoszczedzona_kwote()
BEGIN
    UPDATE budzet
    SET zaoszczedzona_kwota = suma_dochodow - suma_wydatkow;
END;
 
# Procedura wykonująca powyższe procedury
 
CREATE OR REPLACE PROCEDURE Wykonaj_budzet()
BEGIN
    CALL zlicz_dochody_do_budzetu();
    CALL zlicz_wydatki_do_budzetu();
    CALL aktualizuj_zaoszczedzona_kwote();
END;
 
CALL Wykonaj_budzet();
 
UPDATE budzet b
JOIN dom d ON b.nazwa_domu = d.nazwa_domu
JOIN domownicy u ON b.nazwa_uzytkownika = u.nazwa_uzytkownika
SET b.id_domu = d.id_domu,
    b.id_uzytkownika = u.id_uzytkownika
WHERE b.id_domu IS NULL OR b.id_uzytkownika IS NULL;
 
SELECT * FROM budzet;
 
# Tabela cele oszczędnościowe
 
CREATE OR REPLACE TABLE cele_oszczednosciowe (
    id_celu INT AUTO_INCREMENT PRIMARY KEY,
    id_uzytkownika INT,
    nazwa_uzytkownika VARCHAR(50),
    id_domu INT,
    nazwa_domu VARCHAR(50),
    opis_celu VARCHAR(100),
    docelowa_kwota INT,
    id_budzetu INT,
    zaoszczedzona_kwota INT,
    brakujaca_kwota INT,
    data_celu DATE,
    CONSTRAINT fk_cele_oszczednosciowe_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu),
    CONSTRAINT fk_cele_oszczednosciowe_id_uzytkownika FOREIGN KEY (id_uzytkownika) REFERENCES domownicy(id_uzytkownika),
    CONSTRAINT fk_cele_oszczednosciowe_id_budzetu FOREIGN KEY (id_budzetu) REFERENCES budzet(id_budzetu)
);
 
INSERT INTO cele_oszczednosciowe (nazwa_uzytkownika, nazwa_domu, opis_celu, docelowa_kwota, zaoszczedzona_kwota, data_celu)
SELECT
    nazwa_uzytkownika,
    nazwa_domu,
    CASE
        WHEN RAND() < 0.33 THEN 'Wakacje'
        WHEN RAND() < 0.66 THEN 'Zakup nowego samochodu'
        ELSE 'Remont mieszkania'
    END AS opis_celu,
    CASE
        WHEN RAND() < 0.33 THEN FLOOR(RAND() * (10000 - 1000 + 1) + 1000)           
        WHEN RAND() < 0.66 THEN FLOOR(RAND() * (40000 - 10000 + 1) + 10000)        
        ELSE FLOOR(RAND() * (150000 - 50000 + 1) + 50000)                           
    END AS docelowa_kwota,  
    zaoszczedzona_kwota,
    DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 365) DAY) AS data_celu
FROM budzet;
 
# Procedura obliczająca brakującą kwotę
 
CREATE OR REPLACE PROCEDURE aktualizuj_brakujace_kwoty()
BEGIN
    UPDATE cele_oszczednosciowe
    SET brakujaca_kwota = docelowa_kwota - zaoszczedzona_kwota;
END;
 
CALL aktualizuj_brakujace_kwoty();
 
UPDATE cele_oszczednosciowe c
JOIN dom d ON c.nazwa_domu = d.nazwa_domu
JOIN domownicy u ON c.nazwa_uzytkownika = u.nazwa_uzytkownika
JOIN budzet b ON c.nazwa_uzytkownika = b.nazwa_uzytkownika AND c.nazwa_domu = b.nazwa_domu
SET
    c.id_domu = d.id_domu,
    c.id_uzytkownika = u.id_uzytkownika,
    c.id_budzetu = b.id_budzetu
WHERE c.id_domu IS NULL OR c.id_uzytkownika IS NULL OR c.id_budzetu IS NULL;
 
SELECT * FROM cele_oszczednosciowe;
 
# Tabela podsumowania wydatków każdego domu
 
CREATE OR REPLACE TABLE podsumowanie_domu (
    id_podsumowania INT AUTO_INCREMENT PRIMARY KEY,
    id_domu INT,
    nazwa_domu VARCHAR(50),
    suma_dochodow INT,
    suma_wydatkow INT,
    zaoszczedzona_kwota INT,
    CONSTRAINT fk_podsumowanie_domu_id_domu FOREIGN KEY (id_domu) REFERENCES dom(id_domu)
);
 
INSERT INTO podsumowanie_domu (nazwa_domu, suma_dochodow, suma_wydatkow, zaoszczedzona_kwota)
SELECT
    nazwa_domu,
    SUM(suma_dochodow) AS suma_dochodow,
    SUM(suma_wydatkow) AS suma_wydatkow,
    SUM(zaoszczedzona_kwota) AS zaoszczedzona_kwota
FROM
    budzet
GROUP BY
    nazwa_domu;
   
UPDATE podsumowanie_domu p
JOIN dom d ON p.nazwa_domu = d.nazwa_domu
SET p.id_domu = d.id_domu
WHERE p.id_domu IS NULL;
 
SELECT * FROM podsumowanie_domu;

# Tabela reklamy

CREATE OR REPLACE TABLE reklamy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_reklamy VARCHAR(255) NOT NULL,
    opis TEXT,
    sponsor VARCHAR(255)
);
 
INSERT INTO reklamy (nazwa_reklamy, opis, sponsor)
VALUES
    ('Super Oferta', 'Kup teraz i oszczędź 50%!', 'Firma A'),
    ('Wakacje w tropikach', 'Zaplanuj swoje wymarzone wakacje', 'Biuro Podróży XYZ'),
    ('Nowy Smartfon', 'Najlepsza technologia w Twoich rękach', 'TechCorp'),
    ('Zadbaj o zdrowie', 'Suplementy diety najwyższej jakości', 'ZdrowiePlus'),
    ('Promocja na ubrania', 'Stylowe ubrania w niskich cenach', 'ModaLux');
 
SELECT * FROM reklamy;

# Tabela wyświetlone 
 
CREATE OR REPLACE TABLE wyswietlone (
    id_wyswietlenia INT AUTO_INCREMENT PRIMARY KEY,
    id_reklamy INT,
    nazwa_reklamy VARCHAR(255),
    uzytkownik INT,
    nazwa_uzytkownika VARCHAR(100),
    klikniete BOOLEAN,
    data_wyswietlenia DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_reklamy) REFERENCES reklamy(id),
    FOREIGN KEY (uzytkownik) REFERENCES domownicy(id_uzytkownika)
);

# Procedura losująca reklamę dla użytkownika oraz to czy klikął w nią 

CREATE OR REPLACE PROCEDURE LosujReklameDlaUzytkownika()
BEGIN
    DECLARE uzytkownik INT;
    DECLARE id_reklamy INT;
    DECLARE losowe_klikniecie BOOLEAN;
 
    SELECT id_uzytkownika INTO uzytkownik
    FROM domownicy
    ORDER BY RAND()
    LIMIT 1;
 
    SELECT id INTO id_reklamy
    FROM reklamy
    ORDER BY RAND()
    LIMIT 1;
 
    SET losowe_klikniecie = FLOOR(RAND() * 2);
 
    INSERT INTO wyswietlone (id_reklamy, uzytkownik, klikniete)
    VALUES (id_reklamy, uzytkownik, losowe_klikniecie);
END;
  
# Dodajemy kolumny, w których będą się wyświetlać zliczone wartości wyświetleń i kliknięć
  
ALTER TABLE reklamy
ADD COLUMN liczba_wyswietlen INT DEFAULT 0;
 
ALTER TABLE reklamy
ADD COLUMN liczba_klikniec INT DEFAULT 0;
 
UPDATE wyswietlone
SET klikniete = TRUE
WHERE id_reklamy = 1; 
 
SELECT * FROM wyswietlone WHERE klikniete = TRUE;

SELECT * FROM wyswietlone;
  
# Trigger do zwiększania liczby wyświetleń w tabeli reklamy po dodaniu nowego rekordu do wyswietlone

CREATE TRIGGER ZwiekszLiczbeWyswietlen
AFTER INSERT ON wyswietlone
FOR EACH ROW
BEGIN
    UPDATE reklamy
    SET liczba_wyswietlen = liczba_wyswietlen + 1
    WHERE id = NEW.id_reklamy;
END;
 
# Trigger do zwiększania liczby kliknięć w tabeli reklamy po wstawieniu nowego rekordu

CREATE TRIGGER ZwiekszLiczbeKlikniec
AFTER INSERT ON wyswietlone
FOR EACH ROW
BEGIN
    IF NEW.klikniete = TRUE THEN
        UPDATE reklamy
        SET liczba_klikniec = liczba_klikniec + 1
        WHERE id = NEW.id_reklamy;
    END IF;
END;
 
CALL LosujReklameDlaUzytkownika();

# Uzupełnienie kolumn 

UPDATE wyswietlone w
JOIN domownicy d ON w.uzytkownik = d.id_uzytkownika
JOIN reklamy r ON w.id_reklamy = r.id
SET w.nazwa_uzytkownika = d.nazwa_uzytkownika,  
    w.nazwa_reklamy = r.nazwa_reklamy
WHERE w.nazwa_uzytkownika IS NULL
   OR w.nazwa_reklamy IS NULL;

SELECT * FROM wyswietlone;

SELECT * FROM reklamy;
 
# Widok, za pomocą którego sprawdzamy najczęściej wyświelone reklamy
 
CREATE OR REPLACE VIEW ReklamaNajczesciejWyswietlana AS
SELECT r.nazwa_reklamy, COUNT(w.id_reklamy) AS liczba_wyswietlen
FROM reklamy r
JOIN wyswietlone w ON r.id = w.id_reklamy
GROUP BY r.nazwa_reklamy
ORDER BY liczba_wyswietlen DESC;
 
SELECT * FROM ReklamaNajczesciejWyswietlana;

# Widok, za pomocą którego sprawdzamy najczęściej kliknięte reklamy
 
CREATE OR REPLACE VIEW ReklamaNajczesciejKliknieta AS
SELECT r.nazwa_reklamy, COUNT(w.id_reklamy) AS liczba_klikniec
FROM reklamy r
JOIN wyswietlone w ON r.id = w.id_reklamy
WHERE w.klikniete = TRUE
GROUP BY r.nazwa_reklamy
ORDER BY liczba_klikniec DESC;
 
SELECT * FROM ReklamaNajczesciejKliknieta;

# EVENT tworzenia kopii zapasowych

SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS monthly_backup
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
	
    CREATE TABLE IF NOT EXISTS dom_backup AS SELECT * FROM dom WHERE FALSE;
    INSERT INTO dom_backup SELECT * FROM dom;

    CREATE TABLE IF NOT EXISTS domownicy_backup AS SELECT * FROM domownicy WHERE FALSE;
    INSERT INTO domownicy_backup SELECT * FROM domownicy;

    CREATE TABLE IF NOT EXISTS dochody_backup AS SELECT * FROM dochod WHERE FALSE;
    INSERT INTO dochody_backup SELECT * FROM dochod;

    CREATE TABLE IF NOT EXISTS wydatki_backup AS SELECT * FROM wydatki WHERE FALSE;
    INSERT INTO wydatki_backup SELECT * FROM wydatki;
END;

SELECT * FROM dom_backup;

SELECT * FROM domownicy_backup;

SELECT * FROM dochody_backup;

SELECT * FROM wydatki_backup;

# Wywołanie tabeli domownicy

SELECT * FROM domownicy;
