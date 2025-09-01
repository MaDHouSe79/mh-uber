<p align="center">
    <img width="140" src="https://icons.iconarchive.com/icons/iconarchive/red-orb-alphabet/128/Letter-M-icon.png" />  
    <h1 align="center">Hi 👋, I'm MaDHouSe</h1>
    <h3 align="center">A passionate allround developer </h3>    
</p>

<p align="center">
  <a href="https://github.com/MaDHouSe79/mh-uber/issues">
    <img src="https://img.shields.io/github/issues/MaDHouSe79/mh-uber"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-uber/watchers">
    <img src="https://img.shields.io/github/watchers/MaDHouSe79/mh-uber"/> 
  </a> 
  <a href="https://github.com/MaDHouSe79/mh-uber/network/members">
    <img src="https://img.shields.io/github/forks/MaDHouSe79/mh-uber"/> 
  </a>  
  <a href="https://github.com/MaDHouSe79/mh-uber/stargazers">
    <img src="https://img.shields.io/github/stars/MaDHouSe79/mh-uber?color=white"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-uber/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/MaDHouSe79/mh-uber?color=black"/> 
  </a>      
</p>

<p align="center">
    <img src="https://komarev.com/ghpvc/?username=MaDHouSe79&label=Profile%20views&color=3464eb&style=for-the-badge&logo=star&abbreviated=true" alt="MaDHouSe79" style="padding-right:20px;" />
</p>

# My Youtube Channel
- [Subscribe](https://www.youtube.com/@MaDHouSe79)

# MH Uber - A rp city job for qbcore.
- Go to the cityhall to get the job and after that use `F1` to start the job, you must be in a allowed vehicle to use this.
- Use `/usermenu` or `F4` to request an uber, the driver gets a mail on his phone and when acceppted, you get a messages back that he is on his way.
- uber drivers can use the uber menu and bill a player.

# Dependencies
- [oxmysql](https://github.com/overextended/oxmysql/releases/tag/v1.9.3)
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- [qb-radialmenu](https://github.com/qbcore-framework/qb-radialmenu)

# Commands
- '/ubermenu' or F4

# QB Shared Job
```lua
uber = { label = 'Uber', defaultDuty = false, offDutyPay = false, grades = {['0'] = { name = 'Driver', payment = 0 } } },
```

# Add in qb-cityhall
- in config.lua in `Config.AvailableJobs`
```lua
['uber'] = { ['label'] = 'Uber', ['isManaged'] = false },
```

# LICENSE
[GPL LICENSE](./LICENSE)<br />
&copy; [MaDHouSe79](https://www.youtube.com/@MaDHouSe79)