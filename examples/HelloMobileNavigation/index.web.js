import Main from './src/Main.Ios.purs';
import {AppRegistry} from 'react-native';
Main.main();
AppRegistry.runApplication('HelloMobileNavigation', {
  rootTag: document.getElementById('app')
});