/*
import * as pckg from '/package.json';

var v = pckg.default['version'];
*/

declare module '*.json' {
  const value: any;
  export default value;
}
