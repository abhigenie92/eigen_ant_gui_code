function plot_phermone_values(num_stages,num_nodes,node_positions_x,node_positions_y,src_x,src_y,dest_x,dest_y,phermone_matrix )
axis([-10 10 -10 10]);
scatter(src_x,src_y,360,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor','yellow',...
              'LineWidth',1)
hold on;
scatter(dest_x,dest_y,360,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor','green',...
              'LineWidth',1)
for ii=1:num_stages,
    for jj=1:num_nodes,
        axis([-10 10 -10 10]);
        x=node_positions_x(ii,jj);
        y=node_positions_y(ii,jj);
        scatter(x,y,360,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1)
        hold on;
    end
end
%% draw link between first stage and src; last stage and destination
for jj=1:num_nodes,
    x1=node_positions_x(1,jj);
    y1=node_positions_y(1,jj);
    thickness=phermone_matrix(1,1+jj);
    plot([src_x,x1],[src_y,y1],'LineWidth',thickness,'Color','blue');
end
for jj=1:num_nodes,
    x1=node_positions_x(end,jj);
    y1=node_positions_y(end,jj);
    thickness=phermone_matrix(1+(num_nodes*(num_stages-1))+jj,end);
    plot([x1,dest_x],[y1,dest_y],'LineWidth',thickness,'Color','blue');
end
for ii=1:num_stages-1,
    for jj=1:num_nodes,
        % draw a line from this node to the rest in the next stage
        x1=node_positions_x(ii,jj);
        y1=node_positions_y(ii,jj);
        row=(ii-1)*num_nodes+1+jj;
        for kk=1:num_nodes,
           col=ii*num_nodes+1+kk;
           x2=node_positions_x(ii+1,kk);
           y2=node_positions_y(ii+1,kk);
           %plot
           plot([x1,x2],[y1,y2],'LineWidth',phermone_matrix(row,col),'Color','blue');
           hold on;
        end
    end
end
end

