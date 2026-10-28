Luther, Von den Juden und ihren Lügen (1543)
=============================================

Document bilingue
-----------------

luther-des-juifs.tex
    Extraits en regard (paracol) : allemand à gauche, français à droite.
    Chaque passage est précédé de sa page dans WA 53 (commentaire « % WA 53, p. … »).
    Les coupures dans le texte sont marquées par \textelp{}.
    Texte allemand modernisé : document anonyme publié sur le web (reprenant
    peut-être une édition du XXe siècle, à vérifier), sauf les passages de WA 53,
    p. 417, 419, 426-427, 432, 444, 448 et 515, modernisés d’après WA 53.
    Compilation : make (lualatex).

glossaire.inc
    Note sur la traduction (glossaire), incluse à la fin de luther-des-juifs.tex.
    Extension .inc pour que make ne la compile pas seule.

ecarts-honigmann.md
    Écarts relevés dans la traduction Honigmann, passage par passage, chacun
    classé par catégorie (contresens, inexactitude, affaiblissement…). Cite
    longuement Honigmann : non versionné, à ne pas diffuser.

Sources
-------

9782745333315.pdf, 9782745333315.txt
    Traduction française : Des Juifs et de leurs mensonges, édition critique,
    trad. Johannes Honigmann, introduction et notes de Pierre Savy,
    Honoré Champion, 2015 (ISBN 978-2-7453-2847-2). Exemplaire personnel,
    à ne pas diffuser.

nettoyer.py
    Nettoie l'extraction de 9782745333315.pdf faite par pdftotext -layout :
    retire sauts de page, indentation et mention d'achat ; recolle les mots
    coupés ; marque les appels de note [n] et place les notes, sous la forme
    « [n] texte », en bas de leur page ; remet en une colonne l'index.
    pdftotext -layout 9782745333315.pdf brut.txt
    python3 nettoyer.py brut.txt 9782745333315.txt

wa53.pdf
    Weimarer Ausgabe, t. 53 (1920) ; le traité occupe les pages 417 à 552.

Chaîne OCR (texte de WA 53)
---------------------------

ocr/page-*.txt
    OCR brut des pages 432 à 572 du PDF ; clean.py ne garde que les pages
    437 à 572 (= WA 417 à 552, décalage de 20).

ocr/clean.py
    Retire en-têtes, apparat critique, notes, numéros de ligne et renvois
    marginaux ; insère des repères [WA n].
    python3 ocr/clean.py > wa53-von-den-juden-clean.txt

moderniser.py, graphies.tsv
    Remplace des graphies anciennes par des graphies modernes, d'après la table
    graphies.tsv (une correspondance par ligne, séparée par une tabulation).
    python3 moderniser.py graphies.tsv wa53-von-den-juden-clean.txt > wa53-von-den-juden-modern.txt

wa53-von-den-juden-ocr.txt, -clean.txt, -modern.txt
    Résultats successifs. L'OCR reste bruité (environ 5 % de mots erronés,
    notamment le « s » final lu comme un chiffre : E3, da5…) ; le texte sert
    surtout à retrouver les passages dans WA 53.

Utilitaires
-----------

convert.pas
    Transforme chaque ligne non vide de l'entrée standard en
    \chunks{…}{} (colonne française vide), pour préparer luther-des-juifs.tex.

replace.sh
    Corrections typographiques françaises (guillemets, espaces fines insécables).
