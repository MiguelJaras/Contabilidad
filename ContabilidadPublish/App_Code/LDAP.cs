using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.DirectoryServices;

namespace Contabilidad.Web{

    public class LDAP
    {
        string username;
        string pwd;        
        string domain;
        string actualUser;
        string rolID;
        string officeName;
        string name;

        public string UserName
        {
            get { return username; }
            set { username = value; }
        }

        public string Password
        {
            get { return pwd; }
            set { pwd = value; }
        }

        public string ActualUser
        {
            get { return actualUser; }
            set { actualUser = value; }
        }

        public string DefaultPath
        {
            get
            {
                if (string.IsNullOrEmpty(ConfigurationManager.AppSettings[WebConfigConstantsId.LDAPPath])) return "";
                return ConfigurationManager.AppSettings[WebConfigConstantsId.LDAPPath];
            }
        }
        
        public string Domain
        {
            get { return domain; }
            set { domain = value; }
        }

        public string RolID
        {
            get { return rolID; }
            set { rolID = value; }
        }

        public string OfficeName
        {
            get { return officeName; }
            set { officeName = value; }
        }

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public bool IsValidUser()
        {
            bool returnValue;
            string domainAndUsername;
            string usr = actualUser;
            RolID = ",";
                        
            if (actualUser.Contains("\\"))
            {
                domain = actualUser.Split('\\')[0];
                usr = actualUser.Split('\\')[1];
            }
            else
            {
                domain = null;
            }

            if (string.IsNullOrEmpty(domain))
                domainAndUsername = usr;
            else
                domainAndUsername = domain + @"\" + usr;

            DirectoryEntry entry = new DirectoryEntry(DefaultPath, domainAndUsername, pwd);
            DirectorySearcher search = new DirectorySearcher(entry);
            search.Filter = "SAMAccountName=" + usr;
            try
            {
                SearchResultCollection results = search.FindAll();
                returnValue = (results.Count    >   0);
            }
            catch (Exception ex)
            {
                returnValue = false;
            }
            return returnValue;
        }

        public void ExistUser()
        {
            string usr = actualUser;
            string domainAndUsername;
            if (actualUser.Contains("\\"))
            {
                domain = actualUser.Split('\\')[0];
                usr = actualUser.Split('\\')[1];
            }
            else
            {
                domain = null;
            }

            if (string.IsNullOrEmpty(domain))
                domainAndUsername = usr;
            else
                domainAndUsername = domain + @"\" + usr;
            
            DirectoryEntry entry = new DirectoryEntry(DefaultPath, domainAndUsername, pwd);
            DirectorySearcher search = new DirectorySearcher(entry);
            search.Filter = "SAMAccountName=" + username;
            try
            {
                SearchResultCollection results = search.FindAll();
                Exists = true;
                if (results.Count == 0) Exists = false;
                foreach (SearchResult resultados in results)
                {                    
                    ResultPropertyCollection colProperties = resultados.Properties; 
                    //Si no estan dado de alta los atributos buscados del Active Directory, no aparecen.
                    foreach (string key in colProperties.PropertyNames)
                    {
                        foreach (object value in colProperties[key])
                        {
                            if (key.ToString() == "mail")
                                Email = Convert.ToString(value);

                            if (key.ToString() == "displayname")
                                DisplayName = Convert.ToString(value);

                            if (key.ToString() == "givenname")
                                FirstName = Convert.ToString(value);

                            if (key.ToString() == "sn")
                                LastName = Convert.ToString(value);   
                         
                            if (key.ToString() == "company")
                                Sucursal = Convert.ToString(value);

                            if (key.ToString() == "l")
                                Ciudad = Convert.ToString(value);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Exists = false;
            }

            //return userData;
        }
                
            string firstName;
            string lastName;
            string displayName;
            string email;
            string sucursal;
            string ciudad;
            bool exists;

            public string FirstName
            {
                get { return firstName; }
                set { firstName = value; }
            }

            public string LastName
            {
                get { return lastName; }
                set { lastName = value; }
            }

            public string DisplayName
            {
                get { return displayName; }
                set { displayName = value; }
            }          

            public string Email
            {
                get { return email; }
                set { email = value; }
            }

            public string Sucursal
            {
                get { return sucursal; }
                set { sucursal = value; }
            }

            public string Ciudad
            {
                get { return ciudad; }
                set { ciudad = value; }
            }

            public bool Exists
            {
                get { return exists; }
                set { exists = value; }
            }        
    }
}