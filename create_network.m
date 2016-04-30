function [ num_stages,num_nodes,node_positions_x,node_positions_y,src_x,src_y,dest_x,dest_y,phermone_matrix,distance_matrix ] = create_network()
%% get network structure from user
num_stages=input('Enter the number of stages ');
num_nodes=input('Enter the number of nodes in each stage ');
node_positions_x=zeros(num_stages,num_nodes);
node_positions_y=zeros(num_stages,num_nodes);
%% get the node location of source and destination
fprintf('Place the source node \n');
axis([-10 10 -10 10]);
[src_x,src_y] = ginput(1);
scatter(src_x,src_y,360,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor','yellow',...
              'LineWidth',1)
hold on;
fprintf('Place the destination node \n');
axis([-10 10 -10 10]);
[dest_x,dest_y] = ginput(1);
scatter(dest_x,dest_y,360,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor','green',...
              'LineWidth',1)
hold on;

%% get the node locations from the user 
for ii=1:num_stages,
    for jj=1:num_nodes,
        fprintf('Place the node number %d at stage %d \n',jj,ii);
        axis([-10 10 -10 10]);
        [x,y] = ginput(1);
        node_positions_x(ii,jj)=x;
        node_positions_y(ii,jj)=y;
        scatter(x,y,360,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1)
        hold on;
    end
end
distance_matrix=zeros(num_stages*num_nodes+2); % format src s_1n_1 s_1n_2 s2_n_1 s2_n_2.... dest
%% generate the distance matrix and draw the links between nodes in successive stages
distance_matrix=zeros(num_stages*num_nodes+2); % format src s_1n_1 s_1n_2 s2_n_1 s2_n_2.... dest
% src node
for jj=1:num_nodes,
    distance_matrix(1,jj+1)=pdist([src_x,src_y;node_positions_x(1,jj),node_positions_y(1,jj)],'euclidean');
end
% destination node
last_stage=(num_stages-1)*num_nodes+1;
for jj=1:num_nodes,
    distance_matrix(last_stage+jj,end)=pdist([dest_x,dest_y;node_positions_x(end,jj),node_positions_y(end,jj)],'euclidean');
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
           %update distance matrix
           distance_matrix(row,col)=pdist([x1,y1;x2,y2],'euclidean');
           hold on;
        end
    end
end
%% generate phermone matrix
min_phermone=.5;
max_phermone=10;
logical=distance_matrix==0;
random_values = (max_phermone-min_phermone).*rand(size(distance_matrix)) + min_phermone;
random_values(logical)=0;
phermone_matrix=random_values;
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
disp('Distance matrix and phermone matrix generated');

end
