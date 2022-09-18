import * as React from "react";
import { ReactNode } from "react";
import Api from "./Api";
import { UserI } from "./interfaces/interfaces";
import { useCookies } from 'react-cookie';

type authContextType = {
  teacher: UserI | null;
  login: (email: string, password: string) => void;
  signup: (email: string, password: string, firstName: string, lastName: string) => void;
  logout: () => void;
};

const authContextDefaultValues: authContextType = {
  teacher: null,
  login: (email: string, password: string) => { },
  signup: (email: string, password: string, firstName: string, lastName: string) => { },
  logout: () => { },
};

const AuthContext = React.createContext<authContextType>(authContextDefaultValues);

export function useAuth() {
  return React.useContext(AuthContext);
}

export function AuthProvider({ children, defaultTeacher }: { children: ReactNode, defaultTeacher: UserI | null }) {
  const [,, removeCookie] = useCookies(['teacher']);
  const [teacher, setTeacher] = React.useState<UserI | null>(defaultTeacher);

  React.useEffect(() => {
    setTeacher(defaultTeacher);
  }, [defaultTeacher]);

  const auth = {
    teacher,
    login(email: string, password: string) {
      return new Promise<void>(async (res, rej) => {
        try {
          const _teacher = await Api.auth.login(email, password);
          setTeacher(_teacher);
          res();
        }
        catch (error) {
          rej(error);
        }
      });
    },

    signup(email: string, password: string, firstName: string, lastName: string) {
      return new Promise<void>(async (res, rej) => {
        try {
          const _teacher = await Api.auth.signup(email, password, firstName, lastName);
          setTeacher(_teacher);
          res();
        }
        catch (error) {
          rej(error);
        }
      });
    },

    logout() {
      return new Promise<void>((res) => {
        setTeacher(null);
        removeCookie("teacher");
        res();
      });
    }
  };

  return (
    <AuthContext.Provider value={auth}>
      {children}
    </AuthContext.Provider>
  );
}

export default function AuthConsumer() {
  return React.useContext(AuthContext);
}