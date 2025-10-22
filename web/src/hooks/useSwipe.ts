import { useEffect, useRef } from 'react';

interface SwipeHandlers {
    onSwipeLeft?: () => void;
    onSwipeRight?: () => void;
}

export const useSwipe = (handlers: SwipeHandlers) => {
    const touchStartX = useRef<number | null>(null);
    const touchEndX = useRef<number | null>(null);
    const minSwipeDistance = 50;

    useEffect(() => {
        const onTouchStart = (e: TouchEvent) => {
            touchEndX.current = null;
            touchStartX.current = e.targetTouches[0].clientX;
        };

        const onTouchMove = (e: TouchEvent) => {
            touchEndX.current = e.targetTouches[0].clientX;
        };

        const onTouchEnd = () => {
            if (!touchStartX.current || !touchEndX.current) return;
            
            const distance = touchStartX.current - touchEndX.current;
            const isLeftSwipe = distance > minSwipeDistance;
            const isRightSwipe = distance < -minSwipeDistance;

            if (isLeftSwipe && handlers.onSwipeLeft) {
                handlers.onSwipeLeft();
            }
            if (isRightSwipe && handlers.onSwipeRight) {
                handlers.onSwipeRight();
            }
        };

        document.addEventListener('touchstart', onTouchStart);
        document.addEventListener('touchmove', onTouchMove);
        document.addEventListener('touchend', onTouchEnd);

        return () => {
            document.removeEventListener('touchstart', onTouchStart);
            document.removeEventListener('touchmove', onTouchMove);
            document.removeEventListener('touchend', onTouchEnd);
        };
    }, [handlers]);
};