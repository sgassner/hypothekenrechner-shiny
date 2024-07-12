# Hypothekarrechner

Eine interaktive Shiny Web-App zur Berechnung der maximalen Hypothek, des Break Even Zinssatzes und des Deckungsgrades.

## Autor

Sandro Gassner

## Datum

9. September 2023

## Übersicht

Diese Applikation bietet zwei Hauptfunktionen:

1. **Maximale Hypothek:** Berechnung der maximal möglichen Hypothek basierend auf verschiedenen Parametern wie Belehnungsbasis, Zinssatz und Amortisationsdauer.
2. **Maximal kalkulatorischer Zinssatz:** Berechnung des maximalen kalkulatorischen Zinssatzes und des Break Even Zinssatzes.

## Aufruf

Das Tool ist online unter folgendem Link aufrufbar: [Link zum Hypothekarrechner](https://sgassner.shinyapps.io/maxhypo/)

## UI-Beschreibung

Die App besteht aus zwei Hauptseiten, die über die Navigation am oberen Rand zugänglich sind:

### 1. Max. Hypothek

Hier können die folgenden Parameter eingegeben werden:
- **Belehnungsbasis (CHF):** Der Wert der Immobilie.
- **Belehnung 1. Hypothek:** Prozentsatz der ersten Hypothek.
- **Belehnung 2. Hypothek:** Prozentsatz der zweiten Hypothek.
- **Amortisationsdauer (Jahre):** Die Anzahl der Jahre zur Amortisation.
- **Nebenkosten:** Nebenkosten als Prozentsatz der Belehnungsbasis.
- **Einnahmen (CHF):** Jährliche Einnahmen.
- **Kalk. Zins:** Kalkulatorischer Zinssatz.
- **Max. Tragbarkeit:** Maximale Tragbarkeit in Prozent.

Ein Klick auf "Berechnen" zeigt die maximal mögliche Hypothek und visualisiert die Tragbarkeit in einem Plot.

### 2. Max. kalk. Zins

Hier können die folgenden Parameter eingegeben werden:
- **Belehnungsbasis (CHF):** Der Wert der Immobilie.
- **Hypothek (CHF):** Höhe der Hypothek.
- **Belehnung 1. Hypothek:** Prozentsatz der ersten Hypothek.
- **Belehnung 2. Hypothek:** Prozentsatz der zweiten Hypothek.
- **Amortisationsdauer (Jahre):** Die Anzahl der Jahre zur Amortisation.
- **Nebenkosten:** Nebenkosten als Prozentsatz der Belehnungsbasis.
- **Einnahmen (CHF):** Jährliche Einnahmen.
- **Max. Tragbarkeit:** Maximale Tragbarkeit in Prozent.

Ein Klick auf "Zinssatz berechnen" zeigt den maximal kalkulierbaren Zinssatz und den Break Even Zinssatz.
