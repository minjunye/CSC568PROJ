% step 1
for N = [20 50 70]
    total_sim_time=5e5; %simulation time
    total_success=zeros(1, N); %array to record number of packets successfully sent
    p=1/N; %transmission threshold

    % Initialize the counter for current node receiving the transmission.
    receiving_node = 0;
    
    %slotted operation
    for time=1:total_sim_time  %nodes transmit based on a random number    
        trans1 = (rand(1,N)<p);
        if (sum(trans1)==1) %only one node sending?
            total_success(find(trans1))=total_success(find(trans1))+1;
        end
    end

    G = sum(total_success)/ (total_sim_time);
    plot(N, G, 'bo:');
    title('Slotted AlOHA');
    xlabel('Number of nodes');
    ylabel('Throughput');
    % set the plot to scale to the data.
    axis auto;
    % set the domain.
    xlim([0 100]);
    hold on;
end
hold off;


% step 2
% allow for another plot
figure;
% At least one packet will arrive at each node every D unit times
D = 50;
for N = [20 50 70]
    total_sim_time=5e5; %simulation time
    total_success=zeros(1, N); %array to record number of packets successfully sent
    p=1/N; %transmission threshold
    total_fail= zeros(1, N);
    receiver = zeros(1, N);

    % Initialize the counter for current node receiving the transmission.
    receiving_node = 0;
    
    %slotted operation
    for time=1:total_sim_time  %nodes transmit based on a random number    
        if (mod(time, D) == 0) 
            trans1 = (rand(1,N)<p);
            receiving_node = mod(receiving_node + N, N) + 1;

            if (sum(trans1)==1) %only one node sending?
                total_success(find(trans1))=total_success(find(trans1))+1;
                receiver(receiving_node) = receiver(receiving_node) + 1;
            end

            if (sum(trans1)>1)
                total_fail(find(trans1))=total_fail(find(trans1))+1;
            end
        end
    end

    G = sum(total_success)/ (total_sim_time);
    plot(N, G, 'bo:');
    title('Slotted AlOHA');
    xlabel('Number of nodes');
    ylabel('Throughput');
    % set the plot to scale to the data.
    axis auto;
    % It may be necessary to set the limits for the y axis for this step, auto axis
    % sets the format in scientific notation.
    % set the domain.
    xlim([0 100]);
    hold on;
end
hold off;

% step 3
% allow for another plot
figure;
% At least one packet will arrive at each node every D unit times
D = 50;
for N = 20
    total_sim_time=5e5; %simulation time
    total_success=zeros(1, N); %array to record number of packets successfully sent
    p=1/N; %transmission threshold
    total_fail= zeros(1, N);
    receiver = zeros(1, N);

    % Initialize the counter for current node receiving the transmission.
    receiving_node = 0;
    
    %slotted operation
    for time=1:total_sim_time  %nodes transmit based on a random number    
        if (mod(time, D) == 0) 
            delayed = zeros(1, N);
            trans1 = (rand(1,N)<p);
            receiving_node = mod(receiving_node + N, N) + 1;

            if (sum(trans1)==1) %only one node sending?
                total_success(find(trans1))=total_success(find(trans1))+1;
                receiver(receiving_node) = receiver(receiving_node) + 1;
            end

            if (sum(trans1)>1)
                total_fail(find(trans1)) = total_fail(find(trans1))+1;
                delayed(find(trans1)) = 1;
            end
        elseif (sum(delayed) > 0)
            % Retry previous transmission failures.
            total_success(find(delayed, 1, 'first')) = total_success(find(delayed, 1, 'first')) + 1;
            % Removed the successful retransmission from the delayed list.
            delayed(find(delayed, 1, 'first')) = 0;
        end
    end

    % I'm not sure if the graph for step 3 is supposed to be of throughput or just successful
    % re-transmissions.
    G = sum(total_success)/ (total_sim_time);
    plot(N, G, 'bo:');
    title('Slotted AlOHA');
    xlabel('Number of nodes');
    ylabel('Throughput');
    % set the plot to scale to the data.
    axis auto;
    % set the domain.
    xlim([0 100]);
    hold on;
end
hold off;
