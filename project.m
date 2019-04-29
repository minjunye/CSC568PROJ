total_sim_time=5e5; %simulation time
p=1/N; %transmission threshold

% step 1
for N = [20 50 70]
    total_success=zeros(1, N); %array to record number of packets successfully sent

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
    total_success=zeros(1, N); %array to record number of packets successfully sent
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

D = 60;
% step 3
figure; % allow for another plot

total_packets = 0;
% At least one packet will arrive at each node every D unit times
for N = 20
    total_success=zeros(1, N); %array to record number of packets successfully sent
    total_fail= zeros(1, N);
    receiver = zeros(1, N);

    % Initialize the counter for current node receiving the transmission.
    receiving_node = 0;
    
    total_delayed = zeros(1, N);
    delayed = zeros(1, N);
    temp1=0;
    %slotted operation
    for time=1:total_sim_time
        % This simulates sending at least one packet to each node
        % every D unit times.
        if (mod(time, D) == 0) 
            % Reset the delayed transmissions.  This simulates a dealine
            % for retransmission.
            delayed = zeros(1, N);
            trans1 = (rand(1,N)<p);
            
            if (sum(delayed)>0)
                trans1(find(delayed,1,'first'))=1
            end
            
            receiving_node = mod(receiving_node + N, N) + 1;
            
            total_packets = total_packets + sum(trans1);
            
            if (sum(trans1)==1) %only one node sending?
                total_success(find(trans1))=total_success(find(trans1))+1;
                receiver(receiving_node) = receiver(receiving_node) + 1;
            end

            if (sum(trans1)>1)
                % More than one transmission results in collisions.
                total_fail(find(trans1)) = total_fail(find(trans1))+1;
                delayed(find(trans1)) = 1;
            end
            if find(delayed, 1, 'first') == temp1
                delayed(find(delayed, 1, 'first')) = 0;
            end
        % Between each D unit times we try to resend failed transmissions, before
        % reaching the transmission deadline.
        elseif (sum(delayed) > 0)
            % Retry previous transmission failures.
            total_success(find(delayed, 1, 'first')) = total_success(find(delayed, 1, 'first')) + 1;

            % Removed the successful retransmission from the delayed list.
            delayed(find(delayed, 1, 'first')) = 0;
            temp1=find(delayed, 1, 'first');

            total_packets = total_packets + 1;
        end
    end

    % Calculate the percentage of packets received.
    S = (sum(total_success)/ sum(total_packets)) * 100;
    plot(N, S, 'bo:');
    title('Slotted AlOHA');
    xlabel('Number of nodes');
    ylabel('% Packets Received');
    % set the plot to scale to the data.
    axis auto;
    % set the domain.
    xlim([0 100]);
    ylim([0 100]);
    hold on;
end

% step 4
% allow for another plot

total_fail = zeros(1, N);
total_packets = 0;
% At least one packet will arrive at each node every D unit times
for N = 20
    total_success=zeros(1, N); %array to record number of packets successfully sent
    total_fail= zeros(1, N);
    receiver = zeros(1, N);

    % Initialize the counter for current node receiving the transmission.
    receiving_node = 0;
    delayed = zeros(1, N);
    %slotted operation
    for time=1:total_sim_time
        if (mod(time, D) == 0)
            % Reset the delayed transmissions.  This simulates a dealine
            % for retransmission.
            delayed = zeros(1, N);
            trans1 = (rand(1,N)<p);
            receiving_node = mod(receiving_node + N, N) + 1;
            total_packets = total_packets + sum(trans1);
            if (sum(trans1)==1) %only one node sending?
                total_success(find(trans1))=total_success(find(trans1))+1;
                receiver(receiving_node) = receiver(receiving_node) + 1;
            end

            if (sum(trans1)>1)
                % If the transmissions are from neigbhoring nodes, there
                % is a collision; otherwise let packets through.
                senders = find(trans1);
                for i=1:length(senders) - 1
                    if (senders(i) + 1 == senders(i+1))
                        total_fail(senders(i)) = total_fail(senders(i))+1;
                        total_fail(senders(i+1)) = total_fail(senders(i+1))+1;
                        delayed(senders(i)) = 1;
                        delayed(senders(i+1)) = 1;
                    else
                        total_success(senders(i))=total_success(senders(i))+1;
                        receiver(receiving_node) = receiver(receiving_node) + 1;
                    end
                end
            end
        elseif (sum(delayed) > 0)
            % Retry previous transmission failures.
            total_success(find(delayed, 1, 'first')) = total_success(find(delayed, 1, 'first')) + 1;

            % Removed the successful retransmission from the delayed list.
            delayed(find(delayed, 1, 'first')) = 0;
            total_packets = total_packets + 1;
        end
    end

    S = (sum(total_success)/ sum(total_packets)) * 100;
    plot(N, S, 'ro:');
end
hold off;
