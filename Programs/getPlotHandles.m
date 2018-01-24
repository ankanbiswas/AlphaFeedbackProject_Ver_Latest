function [plotHandles,gridPos,plotPos] = getPlotHandles(numRows,numCols,gridPos,gapX,gapY,removeLabels)

if ~exist('numRows','var');           numRows=10;                       end
if ~exist('numCols','var');           numCols=10;                       end
if ~exist('gridPos','var');           gridPos=[0.06 0.06 0.9 0.9];      end
if ~exist('gapX','var');              gapX=0.03;                       end
if ~exist('gapY','var');              gapY=0.08;                        end
if ~exist('removeLabels','var');      removeLabels=2;                   end

width = (gridPos(3) - (numCols-1)*gapX)/numCols;
height= (gridPos(4) - (numRows-1)*gapY)/numRows;

plotHandles = zeros(numRows,numCols);
for i=1:numRows
    yPos = gridPos(2)+(height+gapY)*(numRows-i);
    for j=1:numCols
        xPos = gridPos(1)+ (width+gapX)*(j-1);
        plotHandles(i,j) = subplot('position',[xPos yPos width height]);
        plotPos{i,j} = [xPos yPos width height]; % Added by MD 26-02-2016
    end
end

for i=1:numRows
    for j=1:numCols
        if (i==numRows && j==1)
            if removeLabels == 2
                set(plotHandles(i,j),'XTickLabel',[],'YTickLabel',[]);
            end
        else
            if removeLabels == 1 || removeLabels == 2
                set(plotHandles(i,j),'XTickLabel',[],'YTickLabel',[]);
            end
        end
    end
end
end