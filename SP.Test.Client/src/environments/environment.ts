import * as deepmerge from 'deepmerge';
import { environment as base, ienvironment } from "./environment.base";

export const environment = <ienvironment>deepmerge.all([base, {
  // NOTE: do not alter, use corresponding environment config and rely on deep-merge overrides!
} as ienvironment]);
