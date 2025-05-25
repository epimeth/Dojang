import type { BeltLevel } from '$lib/types/student';

class BeltService {
  private static instance: BeltService;
  private belts: BeltLevel[] = [];

  // Private constructor to ensure singleton pattern
  private constructor() {
    this.initializeBelts();
  }

  public static getInstance(): BeltService {
    if (!BeltService.instance) {
      BeltService.instance = new BeltService();
    }
    return BeltService.instance;
  }

  private initializeBelts(): void {
    // TODO: Ideally, this data would be fetched from a database table (e.g., 'belt_definitions')
    // and an API endpoint. This would allow for easier management and updates
    // without code changes. For now, we use a static list.
    // The 'id' here corresponds to the 'rank' and the auto-generated 'id' in the 'belts' table.
    this.belts = [
      { id: 1, name: 'White', color: '#FFFFFF', order: 1, b64svg: 'B64PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJnaG9zdHdoaXRlIiAvPjwvc3ZnPgo=' },
      { id: 2, name: 'Yellow', color: '#FFFF00', order: 2, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJnb2xkIiAvPjwvc3ZnPgo=' },
      { id: 3, name: 'Senior Yellow', color: '#FDEE00', order: 3, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJnb2xkIiAvPjxyZWN0IHk9IjMzLjMzMyUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImdyZWVuIiAvPjxyZWN0IHk9IjY2LjY2NiUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImdvbGQiIC8+PC9zdmc+Cg==' },
      { id: 4, name: 'Green', color: '#008000', order: 4, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJncmVlbiIgLz48L3N2Zz4K' },
      { id: 5, name: 'Senior Green', color: '#006400', order: 5, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJncmVlbiIgLz48cmVjdCB5PSIzMy4zMzMlIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjxyZWN0IHk9IjY2LjY2NiUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImdyZWVuIiAvPjwvc3ZnPgo=' },
      { id: 6, name: 'Blue', color: '#0000FF', order: 6, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjwvc3ZnPgo=' },
      { id: 7, name: 'Senior Blue', color: '#0000CD', order: 7, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjxyZWN0IHk9IjMzLjMzMyUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjMzLjMzMyUiIGZpbGw9ImZpcmVicmljayIgLz48cmVjdCB5PSI2Ni42NjYlIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIzMy4zMzMlIiBmaWxsPSJtZWRpdW1ibHVlIiAvPjwvc3ZnPgo=' },
      { id: 8, name: 'Red', color: '#FF0000', order: 8, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJmaXJlYnJpY2siIC8+PC9zdmc+Cg==' },
      { id: 9, name: 'Senior Red', color: '#DC143C', order: 9, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSI1MCUiIGZpbGw9ImJsYWNrIiAvPjxyZWN0IHk9IjUwJSIgd2lkdGg9IjEwMCUiIGhlaWdodD0iNTAlIiBmaWxsPSJmaXJlYnJpY2siIC8+PC9zdmc+Cg==' },
      { id: 10, name: 'Black', color: '#000000', order: 10, b64svg: 'PHN2Zz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz48L3N2Zz4K' },
    ];
  }

  public getAllBelts(): BeltLevel[] {
    // Return a copy to prevent external modification of the internal array
    return [...this.belts];
  }

  public getBeltByName(name: string): BeltLevel | undefined {
    return this.belts.find(belt => belt.name.toLowerCase() === name.toLowerCase());
  }

  public getBeltById(id: number): BeltLevel | undefined {
    return this.belts.find(belt => belt.id === id);
  }
}

export const beltsService = BeltService.getInstance();