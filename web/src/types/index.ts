export interface NuiMessageData<T = unknown> {
    action: string;
    data?: T;
}

export interface PlayerData {
  level: number;
  XP: number;
  tokens: number;
  currentTrees: Record<number, boolean>;
  skills: Record<number, boolean>;
  maxActiveQuests: number;
  activeQuests: Record<number, boolean>;
}

export interface Tree {
  id: number;
  name: string;
  description: string;
  price: number;
}

export interface Skill {
  id: number;
  name: string;
  description: string;
  image: string;
  price: number;
  parentTree: number;
  previousSkills: number[];
  nextSkills: number[];
}

export interface Quest {
  id: number;
  name: string;
  description: string;
  XP: number;
  steps: number;
  skillsReference: number[];
  requiredQuests: number[];
  hidden: boolean;
}

export interface PlayerQuest {
  quest: Quest;
  completed: boolean;
  currentStep: number;
}

export interface InitData {
  player: PlayerData;
  trees: Record<number, Tree>;
  skills: Record<number, Skill>;
  quests: Record<number, PlayerQuest>;
}
