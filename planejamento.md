# Planejamento de Limpeza e Padronização

## Fase 1 — Padronização (cosmético, baixo risco)
> Não altera comportamento. Apenas organização e consistência visual.

- [x] Renomear arquivos com nomes genéricos ou inválidos
  - `scenes/level_selection/1.gd` → `btn_fase_animais.gd`
  - `scenes/level_selection/2.gd` → `btn_fase_balanca.gd`
  - `scenes/level_selection/3.gd` → `btn_fase_bau.gd`
  - `scenes/levels/fase_bau/World.gd` → `trunk_puzzle.gd`
  - `scenes/levels/fase_balanca/intro_to_balança.gd` → `intro_to_balanca.gd` (remover acento)
  - `scenes/levels/fase_balanca/intro_to_balança.tscn` → `intro_to_balanca.tscn` (remover acento)
- [x] Remover 18 comentários de template `# Replace with function body.` nos arquivos:
  - `scenes/level_selection/1.gd`, `2.gd`, `3.gd`
  - `scenes/level_selection/mouse_animation.gd`
  - `scenes/menu/MenuPausa.gd`
- [x] Padronizar `@onready` vars para `snake_case` nos scripts:
  - `scenes/intro/story.gd` — `SceneTransitionAnimation` → `scene_transition_anim`
  - `scenes/intro/voice_selection.gd` — `SceneTransitionAnimation` → `scene_transition_anim`
  - `scenes/intro/welcome_background.gd` — `SceneTransitionAnimation`, `InitialText`
  - `scenes/levels/fase_bau/trunk_puzzle.gd` — `Trunk`, `Voices`, abreviações confusas
  - `scenes/levels/fase_balanca/intro_to_balanca.gd` — `Voices`
  - `scenes/levels/fase_bau/trunk_puzzle_introduction.gd` — `Voices`

---

## Fase 2 — Qualidade de código (redução de duplicação)
> Elimina repetição sem alterar a lógica do jogo.

- [x] Centralizar `speak_text()` em `scenes/shared/AutoloadScene.gd`
  - Função duplicada em 6 arquivos: `1.gd`, `2.gd`, `3.gd`, `level_selection.gd`, `balanca.gd`, `foco_balanca.gd`
- [x] Centralizar `wait()` em `scenes/shared/AutoloadScene.gd`
  - Função duplicada em 4 arquivos: `welcome_background.gd`, `balanca.gd`, `intro_to_balanca.gd`, `trunk_puzzle_introduction.gd`
- [x] Unificar `LevelManager.gd` e `LevelManager2.gd` em um único arquivo parametrizado
  - São 95% idênticos — diferem apenas em: pitch do TTS, música de fundo e som de parabéns

---

## Fase 3 — Correção de bugs (encontrados durante auditoria)
> Bugs reais que afetam o comportamento do jogo.

- [x] `scenes/menu/MenuPausa.gd:36` — `==` em vez de `=` (comparação no lugar de atribuição, linha inerte)
- [x] `scenes/level_selection/mouse_animation.gd` — arquivo órfão deletado (referenciava `node_2d.tscn` inexistente)
- [x] `scenes/level_selection/1.gd:25` — tenta carregar `.gd` como cena (deveria ser `.tscn`)
- [x] `scenes/intro/voice_selection.gd:34-39` — índice calculado duas vezes, o primeiro cálculo é sobrescrito imediatamente

---

## Regras de nomenclatura adotadas

| Tipo | Padrão | Exemplo |
|---|---|---|
| Arquivos `.gd` e `.tscn` | `snake_case` | `trunk_puzzle.gd` |
| Classes (`class_name`) | `PascalCase` | `LevelManager` |
| Variáveis e funções | `snake_case` | `speak_text()` |
| Constantes | `UPPER_SNAKE_CASE` | `MAX_COINS` |
| Nós referenciados (`@onready`) | `snake_case` | `scene_transition_anim` |
| Sinais | `snake_case` | `phase_completed` |
