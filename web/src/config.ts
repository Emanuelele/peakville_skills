export const UI_CONFIG = {
  SKILL_NODE_SIZE: 60,
  SKILL_NODE_SPACING_X: 150,
  SKILL_NODE_SPACING_Y: 100,
  SKILL_LINE_WIDTH: 2,
  ANIMATION_DURATION: 200,
  MIN_SWIPE_DISTANCE: 50,
} as const;

export const COLORS = {
  PRIMARY: '#3b82f6',
  SUCCESS: '#10b981',
  ERROR: '#ef4444',
  WARNING: '#f59e0b',
  OWNED: '#10b981',
  LOCKED: '#6b7280',
  UNLOCKABLE: '#3b82f6',
  BACKGROUND: 'rgba(20, 20, 20, 0.95)',
} as const;

export const MESSAGES = {
  ERRORS: {
    TREE_PURCHASE_FAILED: 'Impossibile acquistare l\'albero',
    SKILL_PURCHASE_FAILED: 'Impossibile acquistare la skill',
    QUEST_SELECT_FAILED: 'Impossibile selezionare la quest',
    NETWORK_ERROR: 'Errore di comunicazione con il server',
  },
  SUCCESS: {
    TREE_PURCHASED: 'Albero acquistato con successo',
    SKILL_PURCHASED: 'Skill acquistata con successo',
    QUEST_SELECTED: 'Quest selezionata con successo',
  },
} as const;