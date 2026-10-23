interface Syncable {
    readonly id: string;
    toJson(): Record<string, unknown>;
}

abstract class Entity {
    constructor(public readonly id: string) { }
    abstract label(): string;
}

class Survey extends Entity implements Syncable {
    private photos: string[] = [];
    createdAt: Date;
    constructor(id: string, public readonly pinId: string) {
        super(id);
        this.createdAt = new Date();
    }
    addPhoto(path: string): void {
        this.photos.push(path);
    }
    label(): string {
        return `Survey ${this.id} (${this.photos.length} photos)`;
    }
    toJson() {
        return { id: this.id, pinId: this.pinId, photos: [...this.photos], createdAt: this.createdAt };
    }
}

function Timestamped<T extends new (...a: any[]) => object>(Base: T) {
    return class extends Base {
        readonly createdAt = new Date();
    };
}

const s = new Survey('s-1', 'b-17');
s.addPhoto('IMG_0001.jpg');
console.log(s.label());
console.log(JSON.stringify(s.toJson()));