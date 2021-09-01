import * as deepmerge from 'deepmerge';
import { environment as base, ienvironment } from "./environment.base";

export const environment = <ienvironment>deepmerge.all([base, {
  env: "QA"
} as ienvironment]);
