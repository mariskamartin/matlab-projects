classdef PersonGenerator < handle
    %PERSONGENERATOR allow to generate person data
    
    properties (Access = private)
        %% seznam vsech jmen
        jmenaArray = {}; 
        %% seznam vsech domenovych serveru
        domainsArray = {'gmail.com', 'yahoo.com', 'upce.cz', 'fast.net', 'email.de', 'centrum.cz', 'atlas.cz', 'seznam.cz'}; 
        %% vekovy rozsah cloveka
        vekovyRozsah = [15 85];
        %% pohlavi
        pohlaviArray = {'MALE', 'FEMALE'};
    end
    
    methods (Access = public)
        %%Constructor
        function [this] = PersonGenerator()
            this.nahratJmenaZeSouboru();
        end
        %% Vygeneruje nahodne informace o cloveku, vraci datovou instanci tridy Clovek
        function [clovek] = generujCloveka(this)
            clovek = Clovek();
            clovek.uuid = RandomHelper.nextUUID();
            clovek.jmeno = this.generujJmeno();
            clovek.prijmeni = this.generujJmeno();
            clovek.vek = this.generujVek();
            clovek.pohlavi = this.generujPohlavi();
            clovek.email = this.generujEmail([clovek.prijmeni '.' clovek.jmeno]);
        end
        %% Vygeneruje nahodne jmeno cloveka
        function [jmeno] = generujJmeno(this)
            nahodnyIndexJmena = RandomHelper.nextIntegerFromTo(1, length(this.jmenaArray));
            jmeno = this.jmenaArray{nahodnyIndexJmena}; %vratit hranatymi, tim se zrusi cell a vrati to puvodni string
        end
        %% Vygeneruje nahodne jmeno cloveka
        function [pohlavi] = generujPohlavi(this)
            nahodnyIndex = RandomHelper.nextIntegerFromTo(1, length(this.pohlaviArray));
            pohlavi = this.pohlaviArray{nahodnyIndex}; %vratit hranatymi, tim se zrusi cell a vrati to puvodni string
        end
        %% Vygeneruje nahodne prijmeni a jmeno cloveka
        function [celeJmeno] = generujCeleJmeno(this)
            prijmeni = this.generujJmeno();
            jmeno = this.generujJmeno();
            celeJmeno = [jmeno ' ' prijmeni];
        end
        %% Vygeneruje nahodne jmeno cloveka
        function [vek] = generujVek(this)
            vek = RandomHelper.nextIntegerFromTo(this.vekovyRozsah(1),this.vekovyRozsah(2));
        end
        %% Vygeneruje nahodne email, pripadne jen koncovku pro zadane jmeno
        function [email] = generujEmail(this, jmeno)
            if (nargin == 1)
                jmeno = [this.generujJmeno() '.' this.generujJmeno()];
            end
            nahodnyIndexDomeny = RandomHelper.nextIntegerFromTo(1, length(this.domainsArray));
            email = [lower(jmeno) '@' this.domainsArray{nahodnyIndexDomeny}]; %vratit hranatymi, tim se zrusi cell a vrati to puvodni string
        end
        %% FIXME Vypisovaci funkce vylozene pro debug ucely
        function arr = info(this)
            arr = this.jmenaArray;
            for name = this.jmenaArray
                disp(name);
            end
        end
    end
    
    methods (Access = private)
        %% loads all names from file
        function nahratJmenaZeSouboru(this)
            fid = fopen('names.txt');
            tline = fgetl(fid);
            while ischar(tline)
                namesFromLine = regexp(tline,'\s', 'split');
                this.jmenaArray = [this.jmenaArray namesFromLine];
                tline = fgetl(fid);
            end
            fclose(fid);
        end
    end
end

