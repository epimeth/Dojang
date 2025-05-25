/**
 * Type definition for SvelteKit's fetch function.
 */
export type SvelteKitFetch = typeof fetch;

/**
 * Interface for classes that can be initialized with SvelteKit's fetch.
 * Services using the EnsureFetchInitialized decorator should implement this.
 */
export interface FetchInitializable {
  init(fetchFn: SvelteKitFetch): void;
  _isFetchInitialized(): boolean;
  // It's also implied that the class will have a private/protected _fetch property
}

/**
 * Class Decorator to ensure that the _fetch property (via _isFetchInitialized) is set before any method
 * (except 'init' and '_isFetchInitialized' and 'constructor') is called.
 * It iterates over the prototype methods and wraps them.
 */
export function EnsureFetchInitialized<T extends { new (...args: any[]): FetchInitializable }>(constructor: T) {
  const prototype = constructor.prototype;
  const methodNames = Object.getOwnPropertyNames(prototype)
    .filter(name => name !== 'constructor' && name !== 'init' && name !== '_isFetchInitialized' && typeof prototype[name] === 'function');

  methodNames.forEach(methodName => {
    const originalMethod = prototype[methodName];
    prototype[methodName] = function (...args: any[]) {
      if (!this._isFetchInitialized()) {
        throw new Error(
          `${constructor.name} is not initialized with fetch. Call .init(fetch) first. Attempted to call '${methodName}'.`
        );
      }
      return originalMethod.apply(this, args);
    };
  });
}