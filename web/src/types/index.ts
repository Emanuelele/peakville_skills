export interface NuiMessageData<T = unknown> {
    action: string;
    data?: T;
}

export interface PlayerData {
  level: number;
  XP: number;
  tokens: number;
  currentTrees: Record<string, boolean>;
  skills: Record<string, boolean>;
  maxActiveQuests: number;
  activeQuests: Record<string, boolean>;
}

export interface Tree {
  id: string;
  name: string;
  description: string;
  price: number;
}

export interface Skill {
  id: string;
  name: string;
  description: string;
  image: string;
  price: number;
  parentTree: string;
  previousSkills: string[];
  nextSkills: string[];
}

export interface Quest {
  id: string;
  name: string;
  description: string;
  XP: number;
  steps: number;
  skillsReference: string[];
  requiredQuests: string[];
  actionConfig: Record<string, any>;
  hidden: boolean;
}

export interface PlayerQuest {
  quest: Quest;
  completed: boolean;
  currentStep: number;
}

export interface InitData {
  player: PlayerData;
  trees: Record<string, Tree>;
  skills: Record<string, Skill>;
  quests: Record<string, PlayerQuest>;
  availableActions: Record<string, {
    label: string;
    category: string;
    parameters?: Record<string, { type: string; required: boolean }>;
  }>
}
