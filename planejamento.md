# Documentação de Arquitetura e Padrões — Jornada dos Números

> Documento de referência para o time. Descreve a estrutura atual do projeto,
> decisões de arquitetura, padrões adotados e histórico de melhorias aplicadas.
> Atualizado em: 2026-03-28

---

## Estrutura de Pastas

```
res://
├── assets/
│   ├── audio/
│   │   ├── bgm/        # Músicas de fundo (adventure_time, story, feira_sounds, etc.)
│   │   ├── sfx/        # Efeitos sonoros (Cursor, EnterMenu, correct, wrong, etc.)
│   │   └── voice/      # Falas e TTS (parabéns, pergunta, solução, etc.)
│   ├── backgrounds/    # Imagens de cenário (feiras, baú, floresta, etc.)
│   ├── characters/
│   │   ├── fox/        # Sprites da raposa (Fox_Avatar, Fox_Down, raposinha)
│   │   ├── pig/        # Sprites do porco (Pig_Avatar, Pig_Down, IdlePig, p2)
│   │   └── misc/       # Personagens secundários (wizard, P1)
│   ├── fonts/          # CelticHand.ttf
│   ├── objects/
│   │   ├── coins/      # Moedas numeradas (2–20_moeda, Gold_10, moeda_transparente)
│   │   ├── items/      # Itens mágicos da loja (0–10: poeira, escama, bota, etc.)
│   │   ├── scale/      # Sprites da balança por ângulo (L1/L2, 5/8/12/15 graus)
│   │   ├── trunk/      # Estados do baú (closed, open, opening, animado)
│   │   └── misc/       # Imagens genéricas sem categoria definida
│   └── ui/
│       └── buttons/    # Botões de ação (Button_Blue, Ribbon, Disable)
│                       # Raiz: banners, caixas, chaves, ícones de menu
│
├── dialogue/           # Todos os arquivos do plugin Dialogic
│   ├── characters/     # Definições de personagens (.dch): character, narr
│   ├── styles/         # Estilos de caixa de diálogo (.tres): Char, Narr
│   └── timelines/      # Timelines de diálogo (.dtl): Quiz, intro_balanca,
│                       #   rg_ans, wrong_ans, wrong_simple
│
├── scenes/
│   ├── characters/     # Cenas e script base dos personagens
│   │   ├── animal.gd   # Classe base para animais (fox, pig, piglet herdam)
│   │   ├── fox.tscn
│   │   ├── pig.tscn
│   │   └── piglet.tscn
│   ├── intro/          # Fluxo de entrada do jogo
│   │   ├── welcome_screen.tscn / welcome_background.gd
│   │   ├── story.tscn / story.gd
│   │   ├── voice_selection.tscn / voice_selection.gd / voice_selection.gdshader
│   │   └── transition.tscn / transition_colors.gd
│   ├── level_selection/
│   │   ├── level_selection.tscn / level_selection.gd
│   │   ├── btn_fase_animais.gd   # Botão clicável da fase animais
│   │   ├── btn_fase_balanca.gd   # Botão clicável da fase balança
│   │   └── btn_fase_bau.gd       # Botão clicável da fase baú
│   ├── levels/
│   │   ├── fase_animais/
│   │   │   ├── intro_animais.tscn / intro_animais.gd
│   │   │   ├── main.tscn
│   │   │   ├── level1.tscn       # level_index = 1 (padrão)
│   │   │   ├── level2.tscn       # level_index = 2
│   │   │   ├── LevelManager.gd   # Gerenciador unificado (ver seção abaixo)
│   │   │   ├── audio_controller.tscn / audio_controller.gd
│   │   ├── fase_balanca/
│   │   │   ├── intro_to_balanca.tscn / intro_to_balanca.gd
│   │   │   ├── balanca.tscn / balanca.gd
│   │   │   └── foco_balanca.gd
│   │   └── fase_bau/
│   │       ├── Trunk_Puzzle_Introduction.tscn / trunk_puzzle_introduction.gd
│   │       ├── Trunk_Puzzle.tscn / trunk_puzzle.gd
│   ├── menu/
│   │   ├── config.tscn / config.gd       # Singleton Global
│   │   ├── menu_pausa.tscn / MenuPausa.gd
│   │   └── audio_settings.tscn / audio_settings.gd
│   └── shared/                   # Scripts globais sem cena própria
│       ├── AutoloadScene.gd      # Singleton principal (ver seção abaixo)
│       ├── Camera2D.gd
│       ├── Dialogue.gd
│       └── Dialogue2.gd
│
└── addons/
    └── dialogic/                 # Plugin Dialogic — não modificar
```

---

## Fluxo de Navegação

```
welcome_screen.tscn
    └─> story.tscn
            └─> voice_selection.tscn
                    └─> level_selection.tscn
                            ├─> fase_animais/intro_animais.tscn
                            │       └─> level1.tscn ──> level2.tscn
                            ├─> fase_balanca/intro_to_balanca.tscn
                            │       └─> balanca.tscn
                            └─> fase_bau/Trunk_Puzzle_Introduction.tscn
                                    └─> Trunk_Puzzle.tscn
```

Em qualquer fase, ESC abre `menu_pausa.tscn`, que permite continuar ou voltar ao `level_selection`.

---

## Singletons (Autoloads)

| Nome | Arquivo | Responsabilidade |
|---|---|---|
| `AutoloadScene` | `scenes/shared/AutoloadScene.gd` | Estado global de navegação + utilitários compartilhados |
| `Global` | `scenes/menu/config.gd` | Configurações do jogador (voz TTS selecionada) |
| `AudioController` | `scenes/levels/fase_animais/audio_controller.tscn` | Controle centralizado de áudio (músicas, SFX, volume) |
| `Dialogic` | `addons/dialogic/Core/DialogicGameHandler.gd` | Sistema de diálogos (plugin externo) |

### AutoloadScene — funções utilitárias

```gdscript
# Navegar para cena anterior (usado pelo menu de pausa)
AutoloadScene.previous_scene

# TTS centralizado — substitui speak_text() que estava duplicada em 6 arquivos
AutoloadScene.speak_text("texto", rate)   # rate padrão: 0.8

# Timer assíncrono — substitui wait() que estava duplicada em 4 arquivos
await AutoloadScene.wait(segundos)
```

---

## LevelManager — Gerenciador Unificado da Fase Animais

`LevelManager.gd` controla `level1.tscn` e `level2.tscn` com um único script.
O comportamento é diferenciado pela variável exportada `level_index`:

| Propriedade | level_index = 1 | level_index = 2 |
|---|---|---|
| `pitch` (TTS) | `2.0` | `1.0` |
| Música de fundo | `_play_backmusic()` | `_play_backmusic2()` |
| Som de parabéns | `_play_congrats()` | `_play_congrats2()` |
| Som de resposta errada | `_play_answer()` | `_play_answer2()` |
| Cena de origem | `level1.tscn` | `level2.tscn` |
| Próxima cena (acerto) | `level2.tscn` | `level_selection.tscn` |

`level_index` é definido diretamente na cena via inspetor do Godot.
`level1.tscn` usa o valor padrão (`1`). `level2.tscn` define `level_index = 2`.

---

## Padrões de Nomenclatura

| Tipo | Padrão | Exemplo |
|---|---|---|
| Arquivos `.gd` e `.tscn` | `snake_case` | `trunk_puzzle.gd`, `level_selection.tscn` |
| Classes (`class_name`) | `PascalCase` | `LevelManager` |
| Variáveis e funções | `snake_case` | `speak_text()`, `scene_transition_anim` |
| Constantes | `UPPER_SNAKE_CASE` | `MAX_COINS` |
| Nós referenciados (`@onready`) | `snake_case` | `scene_transition_anim`, `line_edit` |
| Sinais | `snake_case` | `phase_completed` |
| Nomes de nós nas cenas | `PascalCase` ou descritivo livre | `SceneTransitionAnimation`, `LevelManager` |

> **Atenção:** o nome do nó na cena (entre aspas no `$"NomeDoNo"`) é diferente
> do nome da variável GDScript que o referencia. O nó pode ter qualquer nome;
> a variável deve seguir `snake_case`.

---

## Arquivos Gerados — Não Versionar

O `.gitignore` está configurado para ignorar:

```
.godot/               # Cache do editor (reimportações, filesystem cache)
assets/**/*.import    # Metadados de importação de assets (regenerados ao abrir)
dialogue/**/*.import
scenes/**/*.import
*.tmp                 # Arquivos temporários
```

> Os `.import` dentro de `addons/` **são versionados** — fazem parte do plugin Dialogic.

---

## Histórico de Melhorias Aplicadas

### Reorganização de pastas (anterior às fases)
- Criação da estrutura `assets/audio/bgm|sfx|voice`, `assets/backgrounds`, `assets/objects/coins|items|scale|trunk`, `assets/ui/buttons`, `dialogue/timelines|characters|styles`, `scenes/characters`, `scenes/shared`
- Todos os caminhos `res://` nos `.tscn`, `.gd` e `project.godot` foram atualizados por script Python
- Arquivos `.import` e temporários removidos do repositório

### Fase 1 — Padronização
- **Renomeações:** `1.gd/2.gd/3.gd` → `btn_fase_animais/balanca/bau.gd` · `World.gd` → `trunk_puzzle.gd` · `intro_to_balança` → `intro_to_balanca` (acento removido)
- **snake_case:** `SceneTransitionAnimation` → `scene_transition_anim` · `InitialText` → `initial_text` · `Trunk/Voices` e abreviações (`reset_t`, `line_ed`, `op_s`, `enumc`) → nomes descritivos
- **Limpeza:** 18 comentários `# Replace with function body.` removidos

### Fase 2 — Redução de duplicação
- `speak_text()` removida de 6 arquivos → centralizada em `AutoloadScene.speak_text()`
- `wait()` removida de 4 arquivos → centralizada em `AutoloadScene.wait()`
- `LevelManager2.gd` deletado → lógica absorvida por `LevelManager.gd` via `@export var level_index`

### Fase 3 — Correção de bugs
- `MenuPausa.gd`: `==` → `=` na atribuição de `previous_scene` (linha era inerte)
- `voice_selection.gd`: índice calculado duas vezes com `.size()` diferentes (primeiro cálculo era sobrescrito)
- `mouse_animation.gd`: arquivo órfão deletado (não referenciado por nenhuma cena, apontava para `node_2d.tscn` inexistente)
