export const formatPercentage = (current: number, total: number): number => {
  if (total === 0) return 0;
  return Math.floor((current / total) * 100);
};

export const formatTokens = (amount: number): string => {
  return `${amount} token${amount !== 1 ? 's' : ''}`;
};

export const getRefundAmount = (price: number): number => {
  return Math.floor(price / 2);
};

export const truncateText = (text: string, maxLength: number): string => {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength - 3) + '...';
};

export const calculateSkillTreeLayout = (
  skills: Array<{ id: number; previousSkills: number[] }>,
  nodeSize: number,
  spacingX: number,
  spacingY: number
): Map<number, { x: number; y: number; level: number }> => {
  const positions = new Map<number, { x: number; y: number; level: number }>();
  const levels = new Map<number, number>();
  
  const calculateLevel = (skillId: number, visited = new Set<number>()): number => {
    if (levels.has(skillId)) return levels.get(skillId)!;
    if (visited.has(skillId)) return 0;
    
    visited.add(skillId);
    const skill = skills.find(s => s.id === skillId);
    if (!skill || skill.previousSkills.length === 0) {
      levels.set(skillId, 0);
      return 0;
    }
    
    const maxPrevLevel = Math.max(
      ...skill.previousSkills.map(prevId => calculateLevel(prevId, visited))
    );
    const level = maxPrevLevel + 1;
    levels.set(skillId, level);
    return level;
  };
  
  skills.forEach(skill => calculateLevel(skill.id));
  
  const skillsByLevel = new Map<number, number[]>();
  levels.forEach((level, skillId) => {
    if (!skillsByLevel.has(level)) {
      skillsByLevel.set(level, []);
    }
    skillsByLevel.get(level)!.push(skillId);
  });
  
  skillsByLevel.forEach((skillIds, level) => {
    const totalWidth = (skillIds.length - 1) * spacingX;
    const startX = -totalWidth / 2;
    
    skillIds.forEach((skillId, index) => {
      positions.set(skillId, {
        x: startX + index * spacingX,
        y: level * spacingY,
        level
      });
    });
  });
  
  return positions;
};