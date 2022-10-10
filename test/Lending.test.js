const Lending = artifacts.require('./Lending');
require('./helper');

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('Token', ([deployer, user, receiver, exchange]) => {
    let lending;0

    beforeEach(async () => {
        lending = await Lending.new();
    })

    describe('deployment', () => {
        it('track owner', async () => {
            const result = await lending.owner();
            result.toString().should.equal(deployer.toString())
        })
    })

    describe('Enter Pool', () => {
        let lending;
        beforeEach(async () => {
            lending = await Lending.new();
        })

        it('success scenario', async () => {
            await lending.enterPool(user, ether(1),{from: user})
            let lender = await lending.Lenders(user)
            assert.equal(lender[2].toString(), ether(1).toString())
        })
    })

    describe('Exit Pool', () => {
        let lending;
        beforeEach(async () => {
            lending = await Lending.new();
            await lending.enterPool(user, ether(1),{from: user})
        })

        it('exit pool failure scenario', async () => {
            let result = await lending.getExitPoolEstimation(user, ether(1), {from: user, value: ether(1)})
            result.toString().should.equal('0')
        })
    })
})