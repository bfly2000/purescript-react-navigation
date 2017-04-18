module ReactNavigation where

import Prelude
import Control.Monad.Eff (Eff, kind Effect)
import Data.Function.Uncurried (Fn0, Fn2, Fn3, runFn2, runFn3)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import React (ReactClass, ReactElement)
import ReactNative.PropTypes (class NoneEnum, Prop)
import ReactNative.PropTypes.Color (Color)
import ReactNative.Styles (Styles)
import ReactNative.Unsafe.ApplyProps (unsafeApplyProps)

-- | StackNavigator https://reactnavigation.org/docs/navigators/stack#API-Definition

foreign import data NAVIGATION :: Effect

type NavigationEff eff = Eff (nav :: NAVIGATION | eff)

-- | NavigationProp https://reactnavigation.org/docs/navigators/navigation-prop#Screen-Navigation-Prop
newtype NavigationProp = Navigation
  { state :: NavigationState
  }

-- | NavigationState https://reactnavigation.org/docs/navigators/navigation-prop#state-The-screen's-current-stateroute
type NavigationState =
  { routeName :: String
  , key :: String
  , params :: NavigationParams
  }

type NavigationParams = forall p. { | p }

foreign import stackNavigatorImpl :: forall r c props. Fn2 { | r } { | c } (ReactClass props)

-- | Create a StackNavigator with a given map of RouteConfigs and StackNavigatorConfigs
stackNavigator :: forall r c props. { | r } -> { | c } -> ReactClass props
stackNavigator = runFn2 stackNavigatorImpl

-- | Create a StackNavigator with a given map of RouteConfigs
stackNavigator' :: forall r props. { | r } -> ReactClass props
stackNavigator' routeConfig = runFn2 stackNavigatorImpl routeConfig {}

foreign import applyNavigationOptionsImpl :: forall o p. Fn2 (ReactClass {navigation :: NavigationProp | p})
  o (ReactClass {navigation :: NavigationProp | p})

-- | Applies `ScreenNavigationOptions` to a screen
applyNavigationOptions :: forall p. ReactClass { navigation :: NavigationProp | p }
  -> Prop ScreenNavigationOptions -> ReactClass { navigation :: NavigationProp | p }
applyNavigationOptions screen options = runFn2 applyNavigationOptionsImpl screen $ unsafeApplyProps {} options

-- | RouteConfig https://reactnavigation.org/docs/navigators/stack#RouteConfigs
type RouteConfig =
  { screen :: forall p. ReactClass { navigation :: NavigationProp | p }
  , getScreen :: forall p. Fn0 (ReactClass { navigation :: NavigationProp | p })
  , path :: String
  , navigationOptions :: ScreenNavigationOptions
  }

mkRouteConfig :: Prop (RouteConfig) -> RouteConfig
mkRouteConfig config = unsafeApplyProps {} config

-- | ScreenNavigationOptions https://reactnavigation.org/docs/navigators/stack#Screen-Navigation-Options
type ScreenNavigationOptions =
  { title :: String
  , header :: HeaderBarConfig
  }

type HeaderBarConfig =
  { visible :: Boolean
  , title :: String -- TODO String or ReactElement
  , backTitle :: Nullable String
  , right :: ReactElement
  , left :: ReactElement
  , style :: Styles
  , titleStyle :: Styles
  , tintColor :: Color
  , cardStack :: CardStackConfig
  }

mkBackTitle :: Maybe String -> Nullable String
mkBackTitle = toNullable

type CardStackConfig =
  { gesturesEnabled :: Boolean
  }


-- | StackNavigatorConfig https://reactnavigation.org/docs/navigators/stack#StackNavigatorConfig

type StackNavigatorConfig =
  { initialRouteName :: String
  , initialRouteParams :: {}
  }

newtype StackNavigatorConfigMode = StackNavigatorConfigMode String

stackNavigatorConfigMode ::
  { modal :: StackNavigatorConfigMode
  , card :: StackNavigatorConfigMode
  }
stackNavigatorConfigMode =
  { modal: StackNavigatorConfigMode "modal"
  , card: StackNavigatorConfigMode "card"
  }

newtype StackNavigatorConfigHeaderMode = StackNavigatorConfigHeaderMode String

instance stackNavigatorConfigHeaderModeNone :: NoneEnum StackNavigatorConfigHeaderMode where
  none = StackNavigatorConfigHeaderMode "none"

stackNavigatorConfigHeaderMode ::
  { float :: StackNavigatorConfigHeaderMode
  , screen :: StackNavigatorConfigHeaderMode
  , none :: StackNavigatorConfigHeaderMode
  }
stackNavigatorConfigHeaderMode =
  { float: StackNavigatorConfigHeaderMode "float"
  , screen: StackNavigatorConfigHeaderMode "screen"
  , none: StackNavigatorConfigHeaderMode "none"
  }

foreign import navigateImpl :: forall eff params. Fn3 NavigationProp String (Nullable { | params }) ((NavigationEff eff) Unit)

navigate :: forall eff params. NavigationProp -> String -> Maybe { | params } -> NavigationEff eff Unit
navigate nav path params = runFn3 navigateImpl nav path $ toNullable params

navigate' :: forall eff. NavigationProp -> String -> NavigationEff eff Unit
navigate' nav path = runFn3 navigateImpl nav path (toNullable Nothing)

foreign import getParamsImpl :: forall params eff. NavigationProp -> NavigationEff eff params

getParams :: forall params eff. NavigationProp -> NavigationEff eff params
getParams = getParamsImpl
