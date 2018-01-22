function systemParam = initGroup(systemParamIn)

%% Keep existing system parameters
systemParam = systemParamIn;

%% Define new system parameters
systemParam.group.number = 6;
systemParam.group.Member1 = 'Gerard Auguets Pulido';
systemParam.group.Member2 = 'Maria Andreu Ruiz';
systemParam.group.Member3 = 'Salvador Monpeat Lopez';
systemParam.group.enabled = true;

%% Initialize system
% Compute numMembers
systemParam.group.numMembers = 0;
while isfield(systemParam.group,['Member' num2str(systemParam.group.numMembers+1)])
    systemParam.group.numMembers = systemParam.group.numMembers + 1;
end
% Disable if numMembers is equal to 0
if systemParam.group.numMembers == 0
    systemParam.group.enabled = false;
end


%% Show new parameters
if systemParam.group.enabled
    disp('-- Group configuration ----------------------------------------------')
    disp(['Group number : ' num2str(systemParam.group.number)]);
    disp(['Group members: ' num2str(systemParam.group.numMembers)]);
    for i=1:systemParam.group.numMembers
        disp(['   - Member ' num2str(i) ': ' eval(['systemParam.group.Member' num2str(i)])]);
    end
else
    error('No group members have been introduced');
end