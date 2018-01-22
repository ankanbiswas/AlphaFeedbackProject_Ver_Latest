% close varibale window

function closeVariableWindow
desktop = com.mathworks.mde.desk.MLDesktop.getInstance();
desktop.closeGroup('Variables');
end