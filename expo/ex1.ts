type Building = {
    id: string;
    address: string;
    floors: number | null; // null = not surveyed yet
    elevators: number | null;
};

export function describe(b: Building): string {
    const floors = b.floors ?? 'unknown';
    const elevators = b.elevators ?? 'unknown';
    return `${b.address}: ${floors} floors, ${elevators} elevators`;
}

export const b: Building = { id: 'b-17', address: 'Str. Lipscani 12', floors: null, elevators: null };
let count = 3; // inferred: number
// count = 'three'; // error: Type 'string' is not assignable to type 'number'.
console.log(describe(b));
console.log(describe({ ...b, floors: 4, elevators: null }));
console.log(b.floors?.toFixed(1) ?? 'n/a');
console.log(`count is ${count}`);