import { useState } from 'react';
import type { InitData, Tree, Skill } from '../types';
import { fetchNui } from '../utils/fetchNui';

interface SkillsSectionProps {
    data: InitData;
}

export const SkillsSection = ({ data }: SkillsSectionProps) => {
    const [selectedTree, setSelectedTree] = useState<number | null>(null);

    const handlePurchaseTree = async (treeId: number) => {
        const success = await fetchNui<boolean>('purchaseTree', treeId);
        if (!success) {
            console.error('Impossibile acquistare l\'albero');
        }
    };

    const handleRefundTree = async (treeId: number) => {
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
    };

    const handleRefundSkill = async (skillId: number) => {
        const success = await fetchNui<boolean>('refundSkill', skillId);
        if (!success) {
            console.error('Impossibile rimborsare la skill');
        }
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

    return (
        <div>
            <h2>Gestione Skills</h2>
            
            <div>
                <p>Token disponibili: {data.player.tokens}</p>
            </div>

            <div>
                <h3>Alberi delle Skills</h3>
                {Object.values(data.trees).map((tree: Tree) => {
                    const isOwned = data.player.currentTrees[tree.id];
                    const canRefund = isTreeRefundable(tree.id);
                    
                    return (
                        <div key={tree.id}>
                            <h4>{tree.name}</h4>
                            <p>{tree.description}</p>
                            <p>Prezzo: {tree.price} token</p>
                            
                            {!isOwned ? (
                                <button 
                                    onClick={() => handlePurchaseTree(tree.id)}
                                    disabled={data.player.tokens < tree.price}
                                >
                                    Acquista Albero
                                </button>
                            ) : (
                                <>
                                    <p>Albero Posseduto</p>
                                    <button 
                                        onClick={() => setSelectedTree(selectedTree === tree.id ? null : tree.id)}
                                    >
                                        {selectedTree === tree.id ? 'Nascondi' : 'Mostra'} Skills
                                    </button>
                                    {canRefund && (
                                        <button onClick={() => handleRefundTree(tree.id)}>
                                            Rimborsa Albero ({Math.floor(tree.price / 2)} token)
                                        </button>
                                    )}
                                </>
                            )}

                            {selectedTree === tree.id && isOwned && (
                                <div>
                                    <h4>Skills dell'albero {tree.name}</h4>
                                    {getTreeSkills(tree.id).map((skill: Skill) => {
                                        const isOwned = data.player.skills[skill.id];
                                        const canUnlock = isSkillUnlockable(skill);
                                        const canRefund = isSkillRefundable(skill);

                                        return (
                                            <div key={skill.id}>
                                                <h5>{skill.name}</h5>
                                                {skill.image && <img src={skill.image} alt={skill.name} />}
                                                <p>{skill.description}</p>
                                                <p>Prezzo: {skill.price} token</p>
                                                
                                                {skill.previousSkills.length > 0 && (
                                                    <p>Richiede skills: {skill.previousSkills.join(', ')}</p>
                                                )}

                                                {!isOwned ? (
                                                    <button 
                                                        onClick={() => handlePurchaseSkill(skill.id)}
                                                        disabled={!canUnlock || data.player.tokens < skill.price}
                                                    >
                                                        Acquista Skill
                                                    </button>
                                                ) : (
                                                    <>
                                                        <p>Skill Posseduta</p>
                                                        {canRefund && (
                                                            <button onClick={() => handleRefundSkill(skill.id)}>
                                                                Rimborsa Skill ({Math.floor(skill.price / 2)} token)
                                                            </button>
                                                        )}
                                                    </>
                                                )}
                                            </div>
                                        );
                                    })}
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>
        </div>
    );
};