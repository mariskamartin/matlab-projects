classdef ListboxAdapter < handle
    properties (Access = private)
        %% listbox handle
        listbox;
    end
    
    methods
        %% construktor
        function [this] = ListboxAdapter(listboxHandle)
            this.listbox = listboxHandle;
        end
        %% prida text na novy radek (na konec)
        function addString(this, text)
            contents = this.getContent();
            contents{end+1} = text;
            this.setContent(contents);
        end
        %% prida text na zadany index (zadany radek).. (1 je prvni radek)
        function pushString(this, text, index)
            contents = this.getContent();
            for k = length(contents):-1:index
                contents{k+1} = contents{k};
            end
            contents{index} = text;
            this.setContent(contents);
        end
        %% vrati text podle indexu radku (prvni radek je index 1)
        function text = getString(this, index)
            contents = this.getContent();
            text = contents{index};
        end
        %% vrati text z aktualne oznaceneho radku
        function text = getSelectedString(this)
            contents = this.getContent();
            text = contents{this.getSelectedIndex()};
        end
        %% vrati pocet radku
        function pocet = getLength(this)
            contents = this.getContent();
            pocet = length(contents);
        end
    end

    methods (Access = private)
        function contentCellArray = getContent(this)
            contentCellArray = cellstr(get(this.listbox,'String'));
        end
        function setContent(this, contentCellArray)
            set(this.listbox,'String',contentCellArray);
            guidata(this.listbox);            
        end
        function idx = getSelectedIndex(this)
            idx = get(this.listbox,'Value');
        end        
    end
end

