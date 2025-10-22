import type { Skill } from '../../types';
import { Button } from './Button';
import { getRefundAmount, formatTokens } from '../../utils/formatters';

interface SkillDetailsProps {
  skill: Skill;
  isOwned: boolean;
  canUnlock: boolean;
  canRefund: boolean;
  playerTokens: number;
  onPurchase: () => void;
  onRefund: () => void;
}

export const SkillDetails = ({
  skill,
  isOwned,
  canUnlock,
  canRefund,
  playerTokens,
  onPurchase,
  onRefund,
}: SkillDetailsProps) => {
  return (
    <div className="skill-details">
      <div className="skill-details-header">
        {skill.image && (
          <img src={skill.image} alt={skill.name} className="skill-details-image" />
        )}
        <h3>{skill.name}</h3>
      </div>

      <p className="skill-details-description">{skill.description}</p>

      <div className="skill-details-info">
        <div className="info-row">
          <span>Prezzo:</span>
          <span className="info-value">{formatTokens(skill.price)}</span>
        </div>

        {skill.previousSkills.length > 0 && (
          <div className="info-row">
            <span>Richiede Skills:</span>
            <span className="info-value">{skill.previousSkills.join(', ')}</span>
          </div>
        )}

        {skill.nextSkills.length > 0 && (
          <div className="info-row">
            <span>Sblocca:</span>
            <span className="info-value">{skill.nextSkills.join(', ')}</span>
          </div>
        )}
      </div>

      <div className="skill-details-actions">
        {!isOwned ? (
          <Button
            variant="primary"
            onClick={onPurchase}
            disabled={!canUnlock || playerTokens < skill.price}
          >
            {playerTokens < skill.price
              ? 'Token insufficienti'
              : !canUnlock
              ? 'Requisiti non soddisfatti'
              : 'Acquista'}
          </Button>
        ) : (
          <>
            <span className="skill-owned-badge">Posseduta</span>
            {canRefund && (
              <Button
                variant="error"
                size="sm"
                onClick={onRefund}
              >
                Rimborsa ({formatTokens(getRefundAmount(skill.price))})
              </Button>
            )}
          </>
        )}
      </div>
    </div>
  );
};