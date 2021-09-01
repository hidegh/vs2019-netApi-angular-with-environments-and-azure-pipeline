import * as deepmerge from 'deepmerge';
import { environment as base, ienvironment } from "./environment.base";

export const environment = <ienvironment>deepmerge.all([base, {
  production: true,
  env: "PROD"
} as ienvironment]);
