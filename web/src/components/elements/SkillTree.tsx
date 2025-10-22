import { useMemo } from 'react';
import type { Skill } from '../../types';
import { calculateSkillTreeLayout } from '../../utils/formatters';
import { UI_CONFIG, COLORS } from '../../config';

interface SkillTreeProps {
  skills: Skill[];
  ownedSkills: Record<number, boolean>;
  onSkillClick: (skillId: number) => void;
  canAfford: (price: number) => boolean;
}

export const SkillTree = ({ skills, ownedSkills, onSkillClick, canAfford }: SkillTreeProps) => {
  const layout = useMemo(() => {
    return calculateSkillTreeLayout(
      skills,
      UI_CONFIG.SKILL_NODE_SIZE,
      UI_CONFIG.SKILL_NODE_SPACING_X,
      UI_CONFIG.SKILL_NODE_SPACING_Y
    );
  }, [skills]);

  const isSkillUnlockable = (skill: Skill): boolean => {
    if (ownedSkills[skill.id]) return false;
    return skill.previousSkills.every(prevId => ownedSkills[prevId]);
  };

  const getSkillStatus = (skill: Skill): 'owned' | 'unlockable' | 'locked' => {
    if (ownedSkills[skill.id]) return 'owned';
    if (isSkillUnlockable(skill)) return 'unlockable';
    return 'locked';
  };

  const getSkillColor = (skill: Skill): string => {
    const status = getSkillStatus(skill);
    if (status === 'owned') return COLORS.OWNED;
    if (status === 'unlockable' && canAfford(skill.price)) return COLORS.UNLOCKABLE;
    return COLORS.LOCKED;
  };

  const maxY = Math.max(...Array.from(layout.values()).map(p => p.y));
  const minX = Math.min(...Array.from(layout.values()).map(p => p.x));
  const maxX = Math.max(...Array.from(layout.values()).map(p => p.x));

  const viewBoxWidth = maxX - minX + UI_CONFIG.SKILL_NODE_SIZE * 2;
  const viewBoxHeight = maxY + UI_CONFIG.SKILL_NODE_SIZE * 2;
  const offsetX = -minX + UI_CONFIG.SKILL_NODE_SIZE;
  const offsetY = UI_CONFIG.SKILL_NODE_SIZE;

  return (
    <div className="skill-tree-container">
      <svg
        width="100%"
        height="100%"
        viewBox={`0 0 ${viewBoxWidth} ${viewBoxHeight}`}
        preserveAspectRatio="xMidYMid meet"
        className="skill-tree-svg"
      >
        {skills.map(skill => {
          const pos = layout.get(skill.id);
          if (!pos) return null;

          return skill.previousSkills.map(prevId => {
            const prevPos = layout.get(prevId);
            if (!prevPos) return null;

            const x1 = prevPos.x + offsetX;
            const y1 = prevPos.y + offsetY;
            const x2 = pos.x + offsetX;
            const y2 = pos.y + offsetY;

            const isActive = ownedSkills[prevId] && ownedSkills[skill.id];

            return (
              <line
                key={`${prevId}-${skill.id}`}
                x1={x1}
                y1={y1}
                x2={x2}
                y2={y2}
                stroke={isActive ? COLORS.OWNED : COLORS.LOCKED}
                strokeWidth={UI_CONFIG.SKILL_LINE_WIDTH}
                opacity={isActive ? 1 : 0.3}
              />
            );
          });
        })}

        {skills.map(skill => {
          const pos = layout.get(skill.id);
          if (!pos) return null;

          const x = pos.x + offsetX;
          const y = pos.y + offsetY;
          const status = getSkillStatus(skill);
          const color = getSkillColor(skill);

          return (
            <g
              key={skill.id}
              className="skill-node"
              onClick={() => onSkillClick(skill.id)}
              style={{ cursor: 'pointer' }}
            >
              <circle
                cx={x}
                cy={y}
                r={UI_CONFIG.SKILL_NODE_SIZE / 2}
                fill={color}
                stroke="#fff"
                strokeWidth="2"
                opacity={status === 'locked' ? 0.5 : 1}
              />
              
              {skill.image && (
                <image
                  href={skill.image}
                  x={x - UI_CONFIG.SKILL_NODE_SIZE / 3}
                  y={y - UI_CONFIG.SKILL_NODE_SIZE / 3}
                  width={UI_CONFIG.SKILL_NODE_SIZE / 1.5}
                  height={UI_CONFIG.SKILL_NODE_SIZE / 1.5}
                  opacity={status === 'locked' ? 0.5 : 1}
                />
              )}

              <text
                x={x}
                y={y + UI_CONFIG.SKILL_NODE_SIZE / 2 + 20}
                textAnchor="middle"
                fill="#fff"
                fontSize="12"
                fontWeight="500"
              >
                {skill.name}
              </text>
            </g>
          );
        })}
      </svg>
    </div>
  );
};