import { useState } from 'react';
import { Card } from '../elements/Card';
import { Button } from '../elements/Button';
import { Modal } from '../elements/Modal';
import { SkillTree } from '../elements/SkillTree';
import { SkillDetails } from '../elements/SkillDetails';
import { formatTokens, getRefundAmount } from '../../utils/formatters';
import type { InitData, Tree, Skill } from '../../types';
import { fetchNui } from '../../utils/fetchNui';

interface SkillsSectionProps {
    data: InitData;
}

export const SkillsSection = ({ data }: SkillsSectionProps) => {
    const [selectedTree, setSelectedTree] = useState<number | null>(null);
    const [selectedSkill, setSelectedSkill] = useState<number | null>(null);
    const [viewMode, setViewMode] = useState<'grid' | 'tree'>('grid');

    const handlePurchaseTree = async (treeId: number) => {
        const success = await fetchNui<boolean>('purchaseTree', treeId);
        if (!success) {
            console.error('Impossibile acquistare l\'albero');
        }
    };

    const handleRefundTree = async (treeId: number) => {
        if (!confirm('Sei sicuro di voler rimborsare questo albero? Perderai tutte le skills associate.')) {
            return;
        }
        
        const success = await fetchNui<boolean>('refundTree', treeId);
        if (!success) {
            console.error('Impossibile rimborsare l\'albero');
        }
    };

    const handlePurchaseSkill = async (skillId: number) => {
        const success = await fetchNui<boolean>('purchaseSkill', skillId);
        if (!success) {
            console.error('Impossibile acquistare la skill');
        }
        setSelectedSkill(null);
    };

    const handleRefundSkill = async (skillId: number) => {
        if (!confirm('Sei sicuro di voler rimborsare questa skill?')) {
            return;
        }
        
        const success = await fetchNui<boolean>('refundSkill', skillId);
        if (!success) {
            console.error('Impossibile rimborsare la skill');
        }
        setSelectedSkill(null);
    };

    const getTreeSkills = (treeId: number): Skill[] => {
        return Object.values(data.skills).filter(skill => skill.parentTree === treeId);
    };

    const isSkillUnlockable = (skill: Skill): boolean => {
        if (!data.player.currentTrees[skill.parentTree]) return false;
        
        for (const prevSkillId of skill.previousSkills) {
            if (!data.player.skills[prevSkillId]) return false;
        }
        
        return true;
    };

    const isSkillRefundable = (skill: Skill): boolean => {
        if (!data.player.skills[skill.id]) return false;
        
        for (const nextSkillId of skill.nextSkills) {
            if (data.player.skills[nextSkillId]) return false;
        }
        
        return true;
    };

    const isTreeRefundable = (treeId: number): boolean => {
        const treeSkills = getTreeSkills(treeId);
        return treeSkills.every(skill => !data.player.skills[skill.id]);
    };

    const handleSkillClick = (skillId: number) => {
        setSelectedSkill(skillId);
    };

    const selectedSkillData = selectedSkill ? data.skills[selectedSkill] : null;

    return (
        <div className="skills-section">
            <div className="stats-panel">
                <div className="stat-item">
                    <span className="stat-label">Token disponibili</span>
                    <span className="stat-value token-amount">{data.player.tokens}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">Alberi posseduti</span>
                    <span className="stat-value">{Object.keys(data.player.currentTrees).length}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">Skills possedute</span>
                    <span className="stat-value">{Object.keys(data.player.skills).length}</span>
                </div>
            </div>

            <div className="trees-container">
                <h3>Alberi delle Skills</h3>
                <div className="grid">
                    {Object.values(data.trees).map((tree: Tree) => {
                        const isOwned = data.player.currentTrees[tree.id];
                        const canRefund = isTreeRefundable(tree.id);
                        const treeSkills = getTreeSkills(tree.id);
                        const ownedSkillsCount = treeSkills.filter(s => data.player.skills[s.id]).length;
                        
                        return (
                            <Card
                                key={tree.id}
                                title={tree.name}
                                footer={
                                    !isOwned ? (
                                        <Button
                                            variant="primary"
                                            onClick={() => handlePurchaseTree(tree.id)}
                                            disabled={data.player.tokens < tree.price}
                                        >
                                            Acquista ({formatTokens(tree.price)})
                                        </Button>
                                    ) : (
                                        <div className="card-actions">
                                            <Button
                                                variant="primary"
                                                size="sm"
                                                onClick={() => setSelectedTree(selectedTree === tree.id ? null : tree.id)}
                                            >
                                                {selectedTree === tree.id ? 'Nascondi' : 'Mostra'} Skills
                                            </Button>
                                            {canRefund && (
                                                <Button
                                                    variant="error"
                                                    size="sm"
                                                    onClick={() => handleRefundTree(tree.id)}
                                                >
                                                    Rimborsa ({formatTokens(getRefundAmount(tree.price))})
                                                </Button>
                                            )}
                                        </div>
                                    )
                                }
                            >
                                <p>{tree.description}</p>
                                
                                {isOwned && (
                                    <div className="tree-stats">
                                        <span>{ownedSkillsCount} / {treeSkills.length} skills</span>
                                    </div>
                                )}
                            </Card>
                        );
                    })}
                </div>
            </div>

            {selectedTree && data.player.currentTrees[selectedTree] && (
                <div className="skills-container">
                    <div className="skills-header">
                        <h3>Skills: {data.trees[selectedTree]?.name}</h3>
                        <div className="view-toggle">
                            <button
                                className={`toggle-btn ${viewMode === 'grid' ? 'active' : ''}`}
                                onClick={() => setViewMode('grid')}
                            >
                                Griglia
                            </button>
                            <button
                                className={`toggle-btn ${viewMode === 'tree' ? 'active' : ''}`}
                                onClick={() => setViewMode('tree')}
                            >
                                Albero
                            </button>
                        </div>
                    </div>

                    {viewMode === 'grid' ? (
                        <div className="grid">
                            {getTreeSkills(selectedTree).map((skill: Skill) => {
                                const isOwned = data.player.skills[skill.id];
                                const canUnlock = isSkillUnlockable(skill);
                                const canRefund = isSkillRefundable(skill);

                                return (
                                    <Card
                                        key={skill.id}
                                        title={skill.name}
                                        onClick={() => handleSkillClick(skill.id)}
                                        className={isOwned ? 'skill-owned' : canUnlock ? 'skill-unlockable' : 'skill-locked'}
                                        footer={
                                            !isOwned ? (
                                                <Button
                                                    variant="primary"
                                                    size="sm"
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        handlePurchaseSkill(skill.id);
                                                    }}
                                                    disabled={!canUnlock || data.player.tokens < skill.price}
                                                >
                                                    {!canUnlock ? 'Bloccata' : `Acquista (${formatTokens(skill.price)})`}
                                                </Button>
                                            ) : (
                                                <div className="card-actions">
                                                    <span className="skill-owned-badge">✓ Posseduta</span>
                                                    {canRefund && (
                                                        <Button
                                                            variant="error"
                                                            size="sm"
                                                            onClick={(e) => {
                                                                e.stopPropagation();
                                                                handleRefundSkill(skill.id);
                                                            }}
                                                        >
                                                            Rimborsa ({formatTokens(getRefundAmount(skill.price))})
                                                        </Button>
                                                    )}
                                                </div>
                                            )
                                        }
                                    >
                                        {skill.image && (
                                            <img src={skill.image} alt={skill.name} className="skill-image" />
                                        )}
                                        <p>{skill.description}</p>
                                    </Card>
                                );
                            })}
                        </div>
                    ) : (
                        <SkillTree
                            skills={getTreeSkills(selectedTree)}
                            ownedSkills={data.player.skills}
                            onSkillClick={handleSkillClick}
                            canAfford={(price) => data.player.tokens >= price}
                        />
                    )}
                </div>
            )}

            {selectedSkillData && (
                <Modal
                    isOpen={true}
                    onClose={() => setSelectedSkill(null)}
                    title="Dettagli Skill"
                >
                    <SkillDetails
                        skill={selectedSkillData}
                        isOwned={!!data.player.skills[selectedSkillData.id]}
                        canUnlock={isSkillUnlockable(selectedSkillData)}
                        canRefund={isSkillRefundable(selectedSkillData)}
                        playerTokens={data.player.tokens}
                        onPurchase={() => handlePurchaseSkill(selectedSkillData.id)}
                        onRefund={() => handleRefundSkill(selectedSkillData.id)}
                    />
                </Modal>
            )}
        </div>
    );
};