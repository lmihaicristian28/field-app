interface HasId {
    id: string;
}

class MemoryRepo<T extends HasId> {
    private items = new Map<string, T>();
    save(item: T): void {
        this.items.set(item.id, item);
    }
    find(id: string): T | undefined {
        return this.items.get(id);
    }
    count(): number {
        return this.items.size;
    }
    remove(id: string): boolean {
        return this.items.delete(id);
    }
    where(test: (item: T) => boolean): T[] {
        return [...this.items.values()].filter(test);
    }
}

type Pin = { id: string; floors: number; hasShops: boolean };

const repo = new MemoryRepo<Pin>();
repo.save({ id: 'b-1', floors: 4, hasShops: true });
repo.save({ id: 'b-2', floors: 11, hasShops: false });
repo.save({ id: 'b-3', floors: 8, hasShops: true });

const tall = repo.where((p) => p.floors > 5).map((p) => p.id);
const totalFloors = repo.where(() => true).reduce((sum, p) => sum + p.floors, 0);
const shopPins = repo.where((p) => p.hasShops)
    .sort((a, b) => b.floors - a.floors)
    .map((p) => p.id);
console.log(tall.join(','), totalFloors, repo.find('b-9')?.floors ?? 'none');
console.log(shopPins.join(','));