// This file can be replaced during build by using the `fileReplacements` array.
// `ng build ---prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

import * as pckg from '../../package.json';

export interface ienvironment {
  // NOTE:
  // all params are optional as we don't plan to override each of them
  // also this way (interface) we got code-completition and less typos
  production?: boolean,
  env?: string,
  version?: string,

  // extras:
  [key: string]: any;
}

export const environment: ienvironment = {
  production: false,
  env: "[BASE]",
  version: pckg.default['version'],

};

/*
 * In development mode, to ignore zone related error stack frames such as
 * `zone.run`, `zoneDelegate.invokeTask` for easier debugging, you can
 * import the following file, but please comment it out in production mode
 * because it will have performance impact when throw error
 *
 * import 'zone.js/dist/zone-error';  // Included with Angular CLI.
 */
