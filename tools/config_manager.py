import configparser


class config_manager:

    def __init__(self, path):
        self.path = path
        self.conf_parser = configparser.ConfigParser()


        
    
    def read(self):
        print("- Load config file")
        read_ok=self.conf_parser.read(self.path,encoding="utf8")
        ## read list excluding default
        print("- config sections : %s"%self.conf_parser.sections())
        return len(read_ok)!=0 and True or False

    def detail(self):
        ## read config like dict
        conf_bitbucket = self.conf_parser['GLOBAL']
        print(conf_bitbucket['user'])

        """
        The DEFAULT section which provides default values for all other sections"""

        ## read config of different type
        print("\n- Support datatypes")
        forwardx11 = self.conf_parser['GLOBAL'].getboolean('forwardx11')
        int_port = self.conf_parser.getint('USER', 'port')
        float_port = self.conf_parser.getfloat('USER', 'port')
        print("> Get int port = %d type : %s"%(int_port, type(int_port)))
        print("> Get float port = %f type : %s"%(float_port, type(float_port)))

    def write(self,path):
        #self.conf_parser.set("USER","port","11223")
        file_write = open(path,"w")
        self.conf_parser.write(file_write)
        file_write.close()





