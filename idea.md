# AK8POGame

## Popis
Akční plošinová hra se strategickými prvky, kde hráč ovládá samuraje, který musí projít všemi levely, porazit nepřátele a nakonec i finálního bosse.

## Detailní popis
Hráč ovládá postavu samuraje s unikátními schopnostmi. Hra kombinuje prvky plošinovky s taktickým bojem, kde každý úkon spotřebovává vyčerpatelnou výdrž (staminu). Zabíjením nepřátel hráč získává body, které může využít k vylepšení svých schopností a zvýšení svých šancí na úspěch v soubojích.

## Zařazení hry
**Žánr:** Akční, strategická, 2D plošinovka

**Cílová skupina:** Hráči 12-35 let, fanoušci náročnějších platformerů

**Platforma:** PC

## Herní svět a postavy
**Prostředí:** Kouzelný les

**Hlavní postava:** Ronin nazývaný Hiroshi

**Schopnosti:** Útok mečem, skok, sprint

**Zvláštnost:** Hra klade důraz na přesnost, vlastnost velmi důležitou pro 
samuraje. Zasažením nepřítele dojde k doplnění menšího množství staminy, v opačném případě dojde k ubrání části životů hráče.

**Nepřátelé:** 

Pěšáci - základní typ nepřátel, liší se množstvím životů

Velitel pěchoty - finální nepřítel

## Ovládání
Jediná postava, kterou hráč ovládá je samuraj. Pohyb do stran je možný šipkami, dále je podporován skok šipkou nahoru a útok stisknutím mezerníku. Stistknutím P, nebo Esc se zobrazí obrazovka pozastavení hry, kde je možné vidět aktuální statistiku hráče. Nabízí také možnost restartování levelu, nebo návrat na úvodní obrazovku.

## Herní mechaniky

### Snížení životů hráče
![Utok](mechanics\attack.png)

### Smrt hráče
![Smrt](mechanics\death.png)

### Získávání bodů vylepšení

### Vylepšení hráče
![Vylepseni](mechanics\upgrade.png)




## Grafické prvky a zvuky
Všechny grafické prvky a zvuky se nachází v adresáři Assets ve zdrojovém adresáři projektu src. Grafika je ve stylu pixel artu a všechny postavy mají přiřazeny různé animace k akcím, které provádějí (pohyb, útok, poškození). Hráče skrze levely provází energetická hudba v duchu hudebního stylu 8-bit (chiptune), která přirozeně doplňuje atmosféru poskytovanou grafickým stylem hry. Odkazy na použité grafické a hudební prvky je možné najít v souboru resources.md v kořenovém adresáři projektu.

## Přehled levelů
Hra obsahuje 5 levelů, v prvních 4 levelech jsou rozmístěni pěšáci a v posledním se nachází jejich velitel. Postupně se zvyšuje množství nepřátel na level a také náročnost terénu.

### Level 1
![Level1](levels\level1.png)

### Level 2
![Level2](levels\level2.png)

### Level 3
![Level3](levels\level3.png)

### Level 4
![Level4](levels\level4.png)

### Level 5
![Level5](levels\level5.png)

## Technologie použité při vývoji
**Godot 4:** engine pro vývoj hry

**Git:** verzování projektu a spolupráce

**Lucidchart:** návrh diagramů herních mechanik

**Discord:** komunikace

## Tým
Na projektu společně pracovali:

**Josef Susík:** vývojář, projektový manažer, designér

**Lukáš Zavadil:** vývojář, projektový manažer, designér
