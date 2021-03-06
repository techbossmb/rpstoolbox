function answer=sinputdlg(prompt,title,lineNo,defaults,special)

% sinputdlg - special input dialog for tstool


error(nargchk(4,5,nargin));

load secfile                           
ScreenSize=get(0,'ScreenSize');
FigWidth=300;FigHeight=50+50*length(prompt);
FigPos(1)=(ScreenSize(3)-FigWidth)/2;
FigPos(2)=(ScreenSize(4)-FigHeight)/2;
FigPos(3)=FigWidth;
FigPos(4)=FigHeight;

if nargin<5
  answer=inputdlg(prompt,title,lineNo,defaults);
else
  a = figure(...
      'Color',[0.8 0.8 0.8], ...
      'Colormap',mat0, ...
      'Position',FigPos, ...
      'Resize', 'off', ...
      'MenuBar','none', ...
      'NumberTitle','off', ...
      'Name',title, ...
      'Tag','sinputdlg');
  for i=1:length(prompt)
    d=uicontrol('Parent',a,'Style','text','Position',[5 65+50*(length(prompt)-i) 225 25],...
	'HorizontalAlignment', 'left', ...
	'Background',[0.8 0.8 0.8], ...
	'String',prompt{i});
    b(i)=uicontrol('Parent',a, ...
	'Background', [1 1 1], ...
	'Style','edit', ...
	'HorizontalAlignment','left', ...	       
	'Position',[5 50+50*(length(prompt)-i) 225 25], ...
	'String', defaults{i});
    if nargin==5  & special{i}
      c(i)=uicontrol('Parent',a,'Style','checkbox','Position',[235 50+50*(length(prompt)-i) 60 25], ...
	  'HorizontalAlignment', 'left', ...
	  'Background',[0.8 0.8 0.8], ...
	  'String',special{i},'Value',defaults{length(prompt)+i});
    end	 
  end
  d=uicontrol('Parent',a,'Style','pushbutton','Position',[5 5 50 25],'String','Cancel',...
              'Callback','uiresume');
  d=uicontrol('Parent',a,'Style','pushbutton','Position',[245 5 50 25],...
              'String','Ok',...
	      'Callback','set(gcbo,''UserData'',1);uiresume');
	 
	   
     
 uiwait;
 answer={};
 if get(d,'UserData')
   for i=1:length(prompt)
     answer{i}=get(b(i),'String');     
   end
   if nargin==5
     for i=1:length(prompt)
       answer{i+length(prompt)}=0;
       if special{i}
	 answer{i+length(prompt)}=get(c(i),'Value');
       end
     end
   end
 end
end

close(gcf);
	 
